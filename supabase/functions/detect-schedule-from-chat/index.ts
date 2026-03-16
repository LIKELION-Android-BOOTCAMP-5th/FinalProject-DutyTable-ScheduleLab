import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });

  try {
    const p = await req.json();
    const message = p.message as string;
    const currentDate = p.currentDate as string; // "YYYY-MM-DD" 형식
    const previousMessages = (p.previousMessages as string[]) || []; // 이전 메시지들

    const geminiKey = Deno.env.get("GEMINI_API_KEY_OMS");
    if (!geminiKey) {
      throw new Error("GEMINI_API_KEY_OMS environment variable is not set");
    }

    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${geminiKey}`;

    // 현재 메시지 + 이전 메시지들을 함께 분석
    const allMessages = [...previousMessages, message];
    const conversationContext = allMessages.join(" / ");

    const prompt = `You are a Korean schedule detection engine. Analyze the given conversation messages and detect schedule information.

[STRICT Rules - EXPLICIT DATE AND TIME REQUIRED]
1. **MUST have BOTH explicit date AND explicit time** to return detected: true
2. **Date is REQUIRED** - must contain explicit date reference (내일, 다음 주, 3월 16일, 월요일, etc.)
   - DO NOT guess or assume dates from context alone
   - Event names like "프로젝트 중간 미팅" WITHOUT a date = NO DETECTION
3. **Time is REQUIRED** - must contain explicit time (3시, 10시 30분, 오후 2시, 14:00, etc.)
   - DO NOT assume or infer times from event names
   - Event names like "회의", "미팅", "모임" WITHOUT explicit time = NO DETECTION
4. **Date + Time BOTH EXPLICIT** - Both must be clearly stated in the messages
5. **Place is OPTIONAL** - can be null or extracted if present
6. Analyze ALL messages together as a conversation
7. If only place is detected (no explicit date or time), include "placeOnly" field
8. **NEVER infer missing information** - if time is missing, return detected: false (NOT assumed from context)
9. Return ONLY valid JSON

[Current Date Reference]
Today is: ${currentDate}

[Conversation Context]
Multiple messages that may contain schedule information:
"${conversationContext.replace(/"/g, '\\"')}"

[Output Format - REQUIRED EXACT JSON STRUCTURE]
- If BOTH date AND time are EXPLICIT: { "detected": true, "schedule": { "title": "string", "date": "YYYY-MM-DD", "time": "HH:mm", "place": "string or null" } }
- If only place is detected (no explicit date/time): { "detected": false, "placeOnly": "장소명" }
- If nothing detected or missing date/time: { "detected": false }

[Critical Examples - MUST follow these rules]
- "내일 오후 3시" → { "detected": true, "schedule": { "title": "", "date": "2026-03-12", "time": "15:00", "place": null } }
- "프로젝트 중간 미팅" ALONE (no date/time) → { "detected": false } - NOT detected just because it's an event name!
- "강남역에서" (only place) → { "detected": false, "placeOnly": "강남역" }
- "다음 주 월요일 10시 30분" → { "detected": true, "schedule": { "title": "", "date": "2026-03-17", "time": "10:30", "place": null } }
- "회의" ALONE (no date/time) → { "detected": false } - NOT detected without explicit date and time!
- "카페" (only place) → { "detected": false, "placeOnly": "카페" }

Output ONLY valid JSON, nothing else.`;

    const geminiRes = await fetch(geminiUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ contents: [{ parts: [{ text: prompt }] }] })
    });

    const data = await geminiRes.json();

    // candidates 존재 여부 확인
    if (!data.candidates || data.candidates.length === 0 || !data.candidates[0].content) {
      console.error("🚫 Gemini Response Error:", JSON.stringify(data));
      return new Response(JSON.stringify({ detected: false }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" }
      });
    }

    const rawText = data.candidates[0].content.parts[0].text;
    const jsonMatch = rawText.match(/\{[\s\S]*\}/);

    if (!jsonMatch) {
      console.error("🚫 Raw Text from Gemini:", rawText);
      return new Response(JSON.stringify({ detected: false }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" }
      });
    }

    const result = JSON.parse(jsonMatch[0]);

    // 응답 유효성 검증
    if (result.detected === true && result.schedule) {
      const schedule = result.schedule;
      // 날짜와 시간이 모두 있는지 확인
      if (schedule.date && schedule.time) {
        return new Response(JSON.stringify(result), {
          headers: { ...corsHeaders, "Content-Type": "application/json" }
        });
      }
    }
    if (result.detected === false && result.placeOnly) {
      return new Response(JSON.stringify(result), {
        headers: { ...corsHeaders, "Content-Type": "application/json" }
      });
    }

    return new Response(JSON.stringify({ detected: false }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" }
    });

  } catch (e) {
    console.error("❌ Error Detail:", e.message);
    return new Response(JSON.stringify({ detected: false }), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" }
    });
  }
})
