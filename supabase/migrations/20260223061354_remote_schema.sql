


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA "pg_catalog";






CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."calendar_type" AS ENUM (
    'personal',
    'group'
);


ALTER TYPE "public"."calendar_type" OWNER TO "postgres";


CREATE TYPE "public"."repeat_option_type" AS ENUM (
    'daily',
    'weekly',
    'monthly',
    'yearly'
);


ALTER TYPE "public"."repeat_option_type" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."add_owner_to_calendar_members"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
begin
  insert into public.calendar_members (
    calendar_id,
    user_id,
    is_admin
  )
  values (
    new.id,
    new.user_id,
    true
  )
  on conflict do nothing;

  return new;
end;
$$;


ALTER FUNCTION "public"."add_owner_to_calendar_members"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_15_minute_reminders"() RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$BEGIN
    INSERT INTO public.reminder_notifications (
        calendar_id,
        schedule_id,
        user_id,
        first_message,
        reminder_type
    )
    SELECT
        s.calendar_id,
        s.id,
        CASE
            WHEN c.type = 'group' THEN cm.user_id
            ELSE c.user_id
        END AS user_id,
        s.title,
        '15_minutes'
    FROM public.schedules s
    JOIN public.calendars c
        ON s.calendar_id = c.id
    LEFT JOIN public.calendar_members cm
        ON c.type = 'group' AND cm.calendar_id = s.calendar_id
    WHERE
        s.started_at BETWEEN now() AND (now() + INTERVAL '15 minutes')
        AND CASE
                WHEN c.type = 'group' THEN cm.user_id
                ELSE c.user_id
            END IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM public.reminder_notifications rn
            WHERE rn.schedule_id = s.id
              AND rn.user_id = CASE
                    WHEN c.type = 'group' THEN cm.user_id
                    ELSE c.user_id
                  END
              AND rn.reminder_type = '15_minutes'
        );
END;$$;


ALTER FUNCTION "public"."create_15_minute_reminders"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_daily_reminders"() RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    INSERT INTO public.reminder_notifications (
        calendar_id,
        schedule_id,
        user_id,
        first_message,
        reminder_type
    )
    SELECT
        s.calendar_id,
        s.id,
        CASE
            WHEN c.type = 'group' THEN cm.user_id       -- 그룹 캘린더 → 멤버
            ELSE c.user_id                              -- 개인 캘린더 → 소유자
        END AS user_id,
        s.title,
        '1_day'
    FROM public.schedules s
    JOIN public.calendars c
        ON s.calendar_id = c.id
    LEFT JOIN public.calendar_members cm
        ON c.type = 'group' AND cm.calendar_id = s.calendar_id
    WHERE
        s.started_at::date = (current_date + INTERVAL '1 day')
        -- 최종 user_id가 존재하는 경우만
        AND CASE
                WHEN c.type = 'group' THEN cm.user_id
                ELSE c.user_id
            END IS NOT NULL
        -- 이미 같은 유저/스케줄/타입의 알림이 있으면 중복 생성 방지
        AND NOT EXISTS (
            SELECT 1
            FROM public.reminder_notifications rn
            WHERE rn.schedule_id = s.id
              AND rn.user_id = CASE
                    WHEN c.type = 'group' THEN cm.user_id
                    ELSE c.user_id
                  END
              AND rn.reminder_type = '1_day'
        );
END;
$$;


ALTER FUNCTION "public"."create_daily_reminders"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_hourly_reminders"() RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    INSERT INTO public.reminder_notifications (
        calendar_id,
        schedule_id,
        user_id,
        first_message,
        reminder_type
    )
    SELECT
        s.calendar_id,
        s.id,
        CASE
            WHEN c.type = 'group' THEN cm.user_id
            ELSE c.user_id
        END AS user_id,
        s.title,
        '1_hour'
    FROM public.schedules s
    JOIN public.calendars c
        ON s.calendar_id = c.id
    LEFT JOIN public.calendar_members cm
        ON c.type = 'group' AND cm.calendar_id = s.calendar_id
    WHERE
        -- ✅ 지금으로부터 "정확히 1시간 후 ~ 1시간+5분 후" 사이에 시작하는 일정만
        s.started_at BETWEEN (now() + INTERVAL '1 hour')
                         AND (now() + INTERVAL '1 hour' + INTERVAL '5 minutes')
        AND CASE
                WHEN c.type = 'group' THEN cm.user_id
                ELSE c.user_id
            END IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM public.reminder_notifications rn
            WHERE rn.schedule_id = s.id
              AND rn.user_id = CASE
                    WHEN c.type = 'group' THEN cm.user_id
                    ELSE c.user_id
                  END
              AND rn.reminder_type = '1_hour'
        );
END;
$$;


ALTER FUNCTION "public"."create_hourly_reminders"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_reminder"() RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$BEGIN
INSERT INTO public.reminder_notifications (
    calendar_id, schedule_id, user_id, first_message, reminder_type
)
SELECT 
    s.calendar_id, s.id, u.target_user_id, s.title, v.type
FROM public.schedules s
JOIN public.calendars c ON s.calendar_id = c.id
CROSS JOIN LATERAL (
    SELECT '15_minutes' AS type WHERE s.started_at BETWEEN now() AND (now() + INTERVAL '15 minutes')
    UNION ALL
    SELECT '1_hour' WHERE s.started_at BETWEEN (now() + INTERVAL '55 minutes') AND (now() + INTERVAL '1 hour')
    UNION ALL
    SELECT '1_day' WHERE s.started_at BETWEEN (now() + INTERVAL '23 hours 55 minutes') AND (now() + INTERVAL '24 hours')
) v
CROSS JOIN LATERAL (
    SELECT c.user_id AS target_user_id WHERE c.type != 'group'
    UNION ALL
    SELECT cm.user_id FROM public.calendar_members cm WHERE c.type = 'group' AND cm.calendar_id = c.id
) u
WHERE u.target_user_id IS NOT NULL
ON CONFLICT (schedule_id, user_id, reminder_type) DO NOTHING;
END$$;


ALTER FUNCTION "public"."create_reminder"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."delete_all_notifications"("p_user_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  DELETE FROM invite_notifications WHERE user_id = p_user_id;
  DELETE FROM reminder_notifications WHERE user_id = p_user_id;
END;
$$;


ALTER FUNCTION "public"."delete_all_notifications"("p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_notifications"("p_user_id" "uuid") RETURNS TABLE("id" bigint, "user_id" "uuid", "calendar_id" bigint, "type" "text", "message" "text", "created_at" timestamp with time zone)
    LANGUAGE "sql"
    AS $$
  SELECT
    id,
    user_id,
    calendar_id,
    'invite',
    message,
    created_at
  FROM invite_notifications
  WHERE user_id = p_user_id

  UNION ALL

  SELECT
    id,
    user_id,
    calendar_id,
    'reminder',
    first_message,
    created_at
  FROM reminder_notifications
  WHERE user_id = p_user_id

  ORDER BY created_at DESC;
$$;


ALTER FUNCTION "public"."get_notifications"("p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_unread_count"("p_calendar_id" bigint, "p_user_id" "uuid") RETURNS integer
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  unread_count int;
BEGIN
  SELECT COUNT(*) INTO unread_count
  FROM chat_messages
  WHERE calendar_id = p_calendar_id
    AND created_at > (
      SELECT COALESCE(last_read_at, '1970-01-01') 
      FROM calendar_members
      WHERE calendar_id = p_calendar_id
        AND user_id = p_user_id
    );

  RETURN unread_count;
END;
$$;


ALTER FUNCTION "public"."get_unread_count"("p_calendar_id" bigint, "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."transfer_admin_role"("p_calendar_id" integer, "p_new_admin_id" "uuid", "p_old_admin_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  -- 1. 캘린더 소유주 변경
  update calendars set user_id = p_new_admin_id where id = p_calendar_id;
  
  -- 2. 새로운 방장 권한 부여
  update calendar_members set is_admin = true 
  where calendar_id = p_calendar_id and user_id = p_new_admin_id;
  
  -- 3. 이전 방장 권한 해제
  update calendar_members set is_admin = false 
  where calendar_id = p_calendar_id and user_id = p_old_admin_id;
end;
$$;


ALTER FUNCTION "public"."transfer_admin_role"("p_calendar_id" integer, "p_new_admin_id" "uuid", "p_old_admin_id" "uuid") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."calendar_members" (
    "calendar_id" bigint NOT NULL,
    "user_id" "uuid" NOT NULL,
    "is_admin" boolean DEFAULT false NOT NULL,
    "last_read_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."calendar_members" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."calendars" (
    "id" bigint NOT NULL,
    "type" "public"."calendar_type" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "title" "text" NOT NULL,
    "imageURL" "text",
    "description" "text"
);


ALTER TABLE "public"."calendars" OWNER TO "postgres";


COMMENT ON COLUMN "public"."calendars"."user_id" IS '캘린더 방장';



ALTER TABLE "public"."calendars" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."calendars_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."chat_messages" (
    "id" bigint NOT NULL,
    "calendar_id" bigint NOT NULL,
    "message" "text" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."chat_messages" OWNER TO "postgres";


ALTER TABLE "public"."chat_messages" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."chat_messages_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."invite_notifications" (
    "id" bigint NOT NULL,
    "user_id" "uuid" NOT NULL,
    "calendar_id" bigint NOT NULL,
    "message" "text" DEFAULT '캘린더에 초대 받았습니다'::"text" NOT NULL,
    "is_read" boolean DEFAULT false NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "is_accepted" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."invite_notifications" OWNER TO "postgres";


ALTER TABLE "public"."invite_notifications" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."invite_notifications_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."reminder_notifications" (
    "id" bigint NOT NULL,
    "user_id" "uuid" NOT NULL,
    "calendar_id" bigint NOT NULL,
    "schedule_id" bigint NOT NULL,
    "is_read" boolean DEFAULT false NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "reminder_type" "text",
    "first_message" "text" DEFAULT ''::"text"
);


ALTER TABLE "public"."reminder_notifications" OWNER TO "postgres";


ALTER TABLE "public"."reminder_notifications" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."reminder_notifications_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."repeat_days" (
    "schedule_id" bigint NOT NULL,
    "repeat_day" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."repeat_days" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."schedules" (
    "id" bigint NOT NULL,
    "calendar_id" bigint NOT NULL,
    "emotion_tag" "text" DEFAULT '😐'::"text" NOT NULL,
    "color_value" "text" NOT NULL,
    "title" "text" NOT NULL,
    "is_done" boolean DEFAULT false NOT NULL,
    "started_at" timestamp with time zone NOT NULL,
    "ended_at" timestamp with time zone NOT NULL,
    "is_repeat" boolean DEFAULT false NOT NULL,
    "repeat_num" bigint,
    "repeat_option" "public"."repeat_option_type",
    "repeat_count" bigint,
    "weekend_exception" boolean,
    "holiday_exception" boolean,
    "address" "text",
    "longitude" "text",
    "latitude" "text",
    "memo" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "repeat_group_id" "text",
    CONSTRAINT "chk_repeat_validity" CHECK (((("is_repeat" = false) AND ("repeat_num" IS NULL) AND ("repeat_option" IS NULL) AND ("repeat_count" IS NULL)) OR (("is_repeat" = true) AND ("repeat_num" IS NOT NULL) AND ("repeat_option" IS NOT NULL))))
);


ALTER TABLE "public"."schedules" OWNER TO "postgres";


ALTER TABLE "public"."schedules" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."schedules_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "nickname" "text" NOT NULL,
    "email" "text" NOT NULL,
    "profile_url" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "is_google_calendar_connect" boolean DEFAULT false NOT NULL,
    "allowed_notification" boolean NOT NULL,
    "fcm_token" "text"
);


ALTER TABLE "public"."users" OWNER TO "postgres";


ALTER TABLE ONLY "public"."calendar_members"
    ADD CONSTRAINT "calendar_members_pkey" PRIMARY KEY ("calendar_id", "user_id");



ALTER TABLE ONLY "public"."calendars"
    ADD CONSTRAINT "calendars_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."chat_messages"
    ADD CONSTRAINT "chat_messages_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."invite_notifications"
    ADD CONSTRAINT "invite_notifications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."reminder_notifications"
    ADD CONSTRAINT "reminder_notifications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."repeat_days"
    ADD CONSTRAINT "repeat_days_pkey" PRIMARY KEY ("schedule_id", "repeat_day");



ALTER TABLE ONLY "public"."schedules"
    ADD CONSTRAINT "schedules_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."reminder_notifications"
    ADD CONSTRAINT "unique_reminder_look_up" UNIQUE ("schedule_id", "user_id", "reminder_type");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_nickname_key" UNIQUE ("nickname");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



CREATE OR REPLACE TRIGGER "invite_notification" AFTER INSERT ON "public"."invite_notifications" FOR EACH ROW EXECUTE FUNCTION "supabase_functions"."http_request"('https://eexkppotdipyrzzjakur.supabase.co/functions/v1/push', 'POST', '{"Content-type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVleGtwcG90ZGlweXJ6empha3VyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTM4NzA3OSwiZXhwIjoyMDc0OTYzMDc5fQ.Yj2SdDVBCzmaFDB1ZSlZOfK6HYydjPlbdS3kW-8c7XE"}', '{}', '1000');



CREATE OR REPLACE TRIGGER "on_calendar_created" AFTER INSERT ON "public"."calendars" FOR EACH ROW EXECUTE FUNCTION "public"."add_owner_to_calendar_members"();



CREATE OR REPLACE TRIGGER "reminder_notification" AFTER INSERT ON "public"."reminder_notifications" FOR EACH ROW EXECUTE FUNCTION "supabase_functions"."http_request"('https://eexkppotdipyrzzjakur.supabase.co/functions/v1/push', 'POST', '{"Content-type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVleGtwcG90ZGlweXJ6empha3VyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTM4NzA3OSwiZXhwIjoyMDc0OTYzMDc5fQ.Yj2SdDVBCzmaFDB1ZSlZOfK6HYydjPlbdS3kW-8c7XE"}', '{}', '1000');



ALTER TABLE ONLY "public"."calendar_members"
    ADD CONSTRAINT "calendar_members_calendar_id_fkey" FOREIGN KEY ("calendar_id") REFERENCES "public"."calendars"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."calendar_members"
    ADD CONSTRAINT "calendar_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."calendars"
    ADD CONSTRAINT "calendars_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."chat_messages"
    ADD CONSTRAINT "chat_messages_calendar_id_fkey" FOREIGN KEY ("calendar_id") REFERENCES "public"."calendars"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."chat_messages"
    ADD CONSTRAINT "chat_messages_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."invite_notifications"
    ADD CONSTRAINT "invite_notifications_calendar_id_fkey" FOREIGN KEY ("calendar_id") REFERENCES "public"."calendars"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."invite_notifications"
    ADD CONSTRAINT "invite_notifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."reminder_notifications"
    ADD CONSTRAINT "reminder_notifications_calendar_id_fkey" FOREIGN KEY ("calendar_id") REFERENCES "public"."calendars"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."reminder_notifications"
    ADD CONSTRAINT "reminder_notifications_schedule_id_fkey" FOREIGN KEY ("schedule_id") REFERENCES "public"."schedules"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."reminder_notifications"
    ADD CONSTRAINT "reminder_notifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."repeat_days"
    ADD CONSTRAINT "repeat_days_schedule_id_fkey" FOREIGN KEY ("schedule_id") REFERENCES "public"."schedules"("id");



ALTER TABLE ONLY "public"."schedules"
    ADD CONSTRAINT "schedules_calendar_id_fkey" FOREIGN KEY ("calendar_id") REFERENCES "public"."calendars"("id") ON UPDATE CASCADE ON DELETE CASCADE;



CREATE POLICY "Allow authenticated users to view and update their own invite n" ON "public"."invite_notifications" TO "authenticated" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Allow authenticated users to view and update their own reminder" ON "public"."reminder_notifications" TO "authenticated" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can delete their own invite notifications" ON "public"."invite_notifications" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can delete their own reminder notifications" ON "public"."reminder_notifications" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can insert their own profile." ON "public"."users" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() = "id"));



CREATE POLICY "Users can update their own profile." ON "public"."users" FOR UPDATE TO "authenticated" USING (("auth"."uid"() = "id")) WITH CHECK (("auth"."uid"() = "id"));





ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";






ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."calendar_members";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."chat_messages";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."invite_notifications";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."reminder_notifications";









GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";














































































































































































GRANT ALL ON FUNCTION "public"."add_owner_to_calendar_members"() TO "anon";
GRANT ALL ON FUNCTION "public"."add_owner_to_calendar_members"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."add_owner_to_calendar_members"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_15_minute_reminders"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_15_minute_reminders"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_15_minute_reminders"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_daily_reminders"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_daily_reminders"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_daily_reminders"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_hourly_reminders"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_hourly_reminders"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_hourly_reminders"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_reminder"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_reminder"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_reminder"() TO "service_role";



GRANT ALL ON FUNCTION "public"."delete_all_notifications"("p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."delete_all_notifications"("p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."delete_all_notifications"("p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_notifications"("p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_notifications"("p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_notifications"("p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_unread_count"("p_calendar_id" bigint, "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_unread_count"("p_calendar_id" bigint, "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_unread_count"("p_calendar_id" bigint, "p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."transfer_admin_role"("p_calendar_id" integer, "p_new_admin_id" "uuid", "p_old_admin_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."transfer_admin_role"("p_calendar_id" integer, "p_new_admin_id" "uuid", "p_old_admin_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."transfer_admin_role"("p_calendar_id" integer, "p_new_admin_id" "uuid", "p_old_admin_id" "uuid") TO "service_role";
























GRANT ALL ON TABLE "public"."calendar_members" TO "anon";
GRANT ALL ON TABLE "public"."calendar_members" TO "authenticated";
GRANT ALL ON TABLE "public"."calendar_members" TO "service_role";



GRANT ALL ON TABLE "public"."calendars" TO "anon";
GRANT ALL ON TABLE "public"."calendars" TO "authenticated";
GRANT ALL ON TABLE "public"."calendars" TO "service_role";



GRANT ALL ON SEQUENCE "public"."calendars_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."calendars_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."calendars_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."chat_messages" TO "anon";
GRANT ALL ON TABLE "public"."chat_messages" TO "authenticated";
GRANT ALL ON TABLE "public"."chat_messages" TO "service_role";



GRANT ALL ON SEQUENCE "public"."chat_messages_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."chat_messages_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."chat_messages_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."invite_notifications" TO "anon";
GRANT ALL ON TABLE "public"."invite_notifications" TO "authenticated";
GRANT ALL ON TABLE "public"."invite_notifications" TO "service_role";



GRANT ALL ON SEQUENCE "public"."invite_notifications_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."invite_notifications_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."invite_notifications_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."reminder_notifications" TO "anon";
GRANT ALL ON TABLE "public"."reminder_notifications" TO "authenticated";
GRANT ALL ON TABLE "public"."reminder_notifications" TO "service_role";



GRANT ALL ON SEQUENCE "public"."reminder_notifications_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."reminder_notifications_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."reminder_notifications_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."repeat_days" TO "anon";
GRANT ALL ON TABLE "public"."repeat_days" TO "authenticated";
GRANT ALL ON TABLE "public"."repeat_days" TO "service_role";



GRANT ALL ON TABLE "public"."schedules" TO "anon";
GRANT ALL ON TABLE "public"."schedules" TO "authenticated";
GRANT ALL ON TABLE "public"."schedules" TO "service_role";



GRANT ALL ON SEQUENCE "public"."schedules_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."schedules_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."schedules_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_reminder()
 RETURNS void
 LANGUAGE plpgsql
AS $function$BEGIN
INSERT INTO public.reminder_notifications (
    calendar_id, schedule_id, user_id, first_message, reminder_type
)
SELECT 
    s.calendar_id, s.id, u.target_user_id, s.title, v.type
FROM public.schedules s
JOIN public.calendars c ON s.calendar_id = c.id
-- 1단계: 시간 범위에 해당하는 데이터만 먼저 필터링 (Index 활용)
CROSS JOIN LATERAL (
    SELECT '15_minutes' AS type WHERE s.started_at BETWEEN now() AND (now() + INTERVAL '15 minutes')
    UNION ALL
    SELECT '1_hour' WHERE s.started_at BETWEEN (now() + INTERVAL '55 minutes') AND (now() + INTERVAL '1 hour')
    UNION ALL
    SELECT '1_day' WHERE s.started_at BETWEEN (now() + INTERVAL '23 hours 55 minutes') AND (now() + INTERVAL '24 hours')
) v
-- 2단계: 대상자 확장
CROSS JOIN LATERAL (
    SELECT c.user_id AS target_user_id WHERE c.type != 'group'
    UNION ALL
    SELECT cm.user_id FROM public.calendar_members cm WHERE c.type = 'group' AND cm.calendar_id = c.id
) u
WHERE u.target_user_id IS NOT NULL
ON CONFLICT (schedule_id, user_id, reminder_type) DO NOTHING;
END$function$
;


  create policy "Authenticated Insert for Profile Images"
  on "storage"."objects"
  as permissive
  for insert
  to authenticated
with check (((bucket_id = 'profile-images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));



  create policy "Authenticated Update for Profile Images"
  on "storage"."objects"
  as permissive
  for update
  to authenticated
using (((bucket_id = 'profile-images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));



  create policy "Authenticated delete own profile images vejz8c_0"
  on "storage"."objects"
  as permissive
  for delete
  to authenticated
using (((bucket_id = 'profile-images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));



  create policy "Authenticated delete own profile images vejz8c_1"
  on "storage"."objects"
  as permissive
  for select
  to authenticated
using (((bucket_id = 'profile-images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));



  create policy "Public Read Access for Profile Images"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'profile-images'::text));



  create policy "image_upload 1ojwdlz_0"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'calendar-images'::text));



  create policy "image_upload 1ojwdlz_1"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check ((bucket_id = 'calendar-images'::text));



  create policy "image_upload 1ojwdlz_2"
  on "storage"."objects"
  as permissive
  for update
  to public
using ((bucket_id = 'calendar-images'::text));



  create policy "image_upload 1ojwdlz_3"
  on "storage"."objects"
  as permissive
  for delete
  to public
using ((bucket_id = 'calendar-images'::text));



