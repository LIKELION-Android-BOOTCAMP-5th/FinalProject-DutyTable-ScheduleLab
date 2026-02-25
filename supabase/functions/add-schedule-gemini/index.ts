import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.7"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

async function fetchKoreanHolidays(year: number, serviceKey: string): Promise<string[]> {
  const baseUrl = "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getHoliDeInfo";
  const url = `${baseUrl}?serviceKey=${serviceKey}&solYear=${year}&_type=json&numOfRows=50`;

  try {
    const res = await fetch(url);
    const data = await res.json();
    const items = data.response?.body?.items?.item;
    if (!items) return [];
    const holidayList = Array.isArray(items) ? items : [items];
    return holidayList
      .filter(item => item.isHoliday === "Y")
      .map(item => {
        const dateStr = item.locdate.toString();
        return `${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)}`;
      }).sort();
  } catch (e) {
    console.error("🚫 공공데이터 API 호출 실패:", e);
    return [];
  }
}

serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });

  try {
    const p = await req.json();
    const supabase = createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!);

    let dates: string[] = [];
    const repeatGroupId = crypto.randomUUID();

    if (p.isRepeat && p.repeatOption !== 'none') {
      const geminiKey = Deno.env.get("GEMINI_API_KEY");
      const publicDataKey = Deno.env.get("PUBLIC_DATA_API_KEY");

      let realHolidays: string[] = [];
      if (p.holidayException === true) {
        const targetYear = new Date(p.startDate).getFullYear();
        realHolidays = await fetchKoreanHolidays(targetYear, publicDataKey!);
      }

      const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${geminiKey}`;

      const prompt = `You are a precision calendar engine. Generate exactly ${p.repeatCount} dates in a JSON object.
      [Strict Reference: South Korean Public Holidays]
      ${realHolidays.length > 0 ? realHolidays.join(", ") : "None"}
      [Input Data]
      - Start Date: ${p.startDate}
      - Interval: Every ${p.repeatNum} valid days.
      - Skip Rules: Weekends(${p.weekendException}), Holidays(${p.holidayException}), ExcludedDates([${p.excludedDates?.join(', ')}]).
      [Rules]
      1. A "Valid Day" is NOT a weekend(if exception is true), NOT a holiday(if exception is true), and NOT in the Excluded list.
      2. Count exactly ${p.repeatNum} "Valid Days" starting from the day after the current scheduled date.
      [Output Structure]
      { "dates": ["YYYY-MM-DD", ...], "summary": "explanation" }`;

      const geminiRes = await fetch(geminiUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ contents: [{ parts: [{ text: prompt }] }] })
      });

      const data = await geminiRes.json();

      // [수정된 안전 로직]: candidates 존재 여부 확인
      if (!data.candidates || data.candidates.length === 0 || !data.candidates[0].content) {
        console.error("🚫 Gemini Response Error:", JSON.stringify(data));
        throw new Error("Gemini did not return any candidates. Check API Key or Safety Filters.");
      }

      const rawText = data.candidates[0].content.parts[0].text;
      const jsonMatch = rawText.match(/\{[\s\S]*\}/);

      if (!jsonMatch) {
        console.error("🚫 Raw Text from Gemini:", rawText);
        throw new Error("Could not find JSON structure in Gemini response.");
      }

      dates = JSON.parse(jsonMatch[0]).dates;
    } else {
      dates = [p.startDate];
    }

    // dates가 비어있는지 마지막 확인
    if (!dates || dates.length === 0) {
      throw new Error("No dates were generated.");
    }

    // Insert 로직 (p.startTime 등 변수명 확인 완료)
const schedulesToInsert = dates.map((date) => ({
      calendar_id: p.calendarId,
      title: p.title,
      emotion_tag: p.emotionTag,
      color_value: p.colorValue,
      is_done: p.isDone || false,
      is_repeat: p.isRepeat,
      repeat_option: p.repeatOption,
      repeat_num: p.repeatNum,
      repeat_count: p.repeatCount,
      address: p.address,
      latitude: p.latitude,
      longitude: p.longitude,
      memo: p.memo,
      started_at: `${date}T${p.startTime}:00Z`,
      ended_at: `${date}T${p.endTime}:00Z`,
      weekend_exception: p.weekendException || false,
      holiday_exception: p.holidayException || false,
      repeat_group_id: repeatGroupId,
      // [핵심] 여기에 제외된 날짜 배열을 함께 저장합니다.
      excluded_dates: p.excludedDates || []
    }));

    const { error: insertErr } = await supabase
      .from('schedules')
      .insert(schedulesToInsert);

    if (insertErr) throw insertErr;

    return new Response(JSON.stringify({
      success: true,
      count: dates.length,
      repeatGroupId: repeatGroupId
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" }
    });

  } catch (e) {
    console.error("❌ Error Detail:", e.message);
    return new Response(JSON.stringify({ error: e.message }), {
      status: 400,
      headers: corsHeaders
    });
  }
})
