import { createClient } from 'npm:@supabase/supabase-js@2'
import { JWT } from 'npm:google-auth-library@9'
import serviceAccount from '../service-account.json' with { type: 'json' }

interface invite_notifications {
  id: string
  user_id: string
  calendar_id: string
  message: string
}

interface reminder_notifications {
  id: string
  user_id: string
  calendar_id : string
  schedule_id : string
  first_message: string
}

interface WebhookPayload {
  type: 'INSERT'
  table: 'invite_notifications' | 'reminder_notifications'
  record: invite_notifications | reminder_notifications
  schema: 'public'
}

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

Deno.serve(async (req) => {
  const payload: WebhookPayload = await req.json()

  let targetUserId: string;
  let notificationTitle: string;
  let notificationBody: string = '새로운 알림이 도착했습니다.';

  // 캘린더 이름 조회
  const { data: calendarData, error: calendarError } = await supabase
    .from('calendars')
    .select('title')
    .eq('id', payload.record.calendar_id)
    .single()

  // 캘린더 이름 없을 경우 예외 처리
  if (calendarError || !calendarData) {
    console.error('Failed to fetch calendar title:', calendarError)
    notificationTitle = '새로운 알림';
  } else {
    notificationTitle = calendarData.title;
  }

  // 초대 알림
  if (payload.table === 'invite_notifications') {
    const record = payload.record as invite_notifications;

    targetUserId = record.user_id;
    notificationBody = record.message;

  }
  // 일정 알림
  else if (payload.table === 'reminder_notifications') {
  const record = payload.record as reminder_notifications;

  // 일정 제목 조회
  const { data: scheduleData, error: scheduleError } = await supabase
    .from('schedules')
    .select('title')
    .eq('id', record.schedule_id)
    .single()

  // 받는 사람
  targetUserId = record.user_id;

  // 기본값
  let scheduleTitle = '일정';

  if (scheduleError || !scheduleData) {
          console.error('Failed to fetch schedule title:', scheduleError);
      } else {
          scheduleTitle = scheduleData.title;
      }

  notificationBody = `${record.first_message}`;


  } else {
    return new Response(JSON.stringify({ error: `Unsupported table: ${payload.table}` }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
    });
  }

  const { data: userData, error: userError } = await supabase
      .from('users')
      .select('fcm_token, allowed_notification')
      .eq('id', targetUserId)
      .single()

  if (userError || !userData || !userData.fcm_token) {
    console.error('Failed to fetch user or FCM token:', userError)
    return new Response(JSON.stringify({ message: 'User or FCM token not found. Notification skipped.' }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
    })
  }

if (!userData.allowed_notification) {
  console.log(`User ${targetUserId} has notifications disabled. Skipping.`);
  return new Response(JSON.stringify({ message: 'Notification is disabled by user.' }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
  })
}

  const fcmToken = userData.fcm_token as string

  const accessToken = await getAccessToken({
    clientEmail: serviceAccount.client_email,
    privateKey: serviceAccount.private_key,
  })

const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        message: {
          token: fcmToken,
          notification: {
            title: notificationTitle,
            body: notificationBody,
          },
          android: {
            priority: 'HIGH',
            notification: {
              channel_id: 'fcm_head_up_channel_id'
            }
          }
        }
      }),
    }
  )

  const resData = await res.json()
  if (res.status < 200 || 299 < res.status) {
    throw resData
  }

  return new Response(JSON.stringify(resData), {
    headers: { 'Content-Type': 'application/json' },
  })
})

const getAccessToken = ({
  clientEmail,
  privateKey,
}: {
  clientEmail: string
  privateKey: string
}): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
    })
    jwtClient.authorize((err, tokens) => {
      if (err) {
        reject(err)
        return
      }
      resolve(tokens!.access_token!)
    })
  })
}
