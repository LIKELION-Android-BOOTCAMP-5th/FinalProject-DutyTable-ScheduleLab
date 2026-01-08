package com.schedulelab.dutytable

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.RemoteViews
import org.json.JSONObject
import java.util.*

class MyWidgetProvider : AppWidgetProvider() {
  override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
    for (appWidgetId in appWidgetIds) {
      val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
      val views = RemoteViews(context.packageName, R.layout.my_widget_provider)

      // 1. 기본 텍스트 정보 반영 (월 정보 및 오늘 날짜 요약)
      views.setTextViewText(R.id.month_text, prefs.getString("current_month_text", ""))
      views.setTextViewText(R.id.today_info_text, prefs.getString("date_key", ""))

      // 2. 달력 데이터 및 일정 JSON 가져오기
      val lastDayStr = prefs.getString("last_day", "31") ?: "31"
      val offsetStr = prefs.getString("first_day_offset", "0") ?: "0"
      val calendarJson = prefs.getString("calendar_json", "{}") ?: "{}"

      val lastDay = lastDayStr.toIntOrNull() ?: 31
      val offset = offsetStr.toIntOrNull() ?: 0
      val calendarData = JSONObject(calendarJson)

      // 오늘 날짜 정보 가져오기 (하이라이트용)
      val now = Calendar.getInstance()
      val todayDate = now.get(Calendar.DAY_OF_MONTH)

      // 3. 42개의 날짜 칸(Cell) 채우기 루프
      for (i in 1..42) {
        // 각 칸의 ID를 가져옵니다 (날짜 숫자용, 일정 텍스트용)
        val dayResId = context.resources.getIdentifier("day_$i", "id", context.packageName)
        val dutyResId = context.resources.getIdentifier("duty_$i", "id", context.packageName)

        if (dayResId == 0 || dutyResId == 0) continue

        val dayNumber = i - offset

        if (dayNumber in 1..lastDay) {
          // --- (A) 날짜 숫자 표시 ---
          views.setTextViewText(dayResId, dayNumber.toString())
          views.setViewVisibility(dayResId, View.VISIBLE)

          // --- (B) 오늘 날짜 하이라이트 ---
          if (dayNumber == todayDate) {
            views.setInt(dayResId, "setBackgroundResource", R.drawable.today_circle)
            views.setTextColor(dayResId, Color.WHITE)
          } else {
            views.setInt(dayResId, "setBackgroundResource", 0)
            views.setTextColor(dayResId, Color.BLACK)
          }

          // --- (C) 일정(Duty) 표시 ---
          if (calendarData.has(dayNumber.toString())) {
            val scheduleRaw = calendarData.getString(dayNumber.toString())
            val scheduleTitle = scheduleRaw.split("|").getOrNull(0) ?: ""

            views.setTextViewText(dutyResId, scheduleTitle)
            views.setViewVisibility(dutyResId, View.VISIBLE)
            // 일정 텍스트 색상 (배경이 흰색이므로 검정/회색 계열 추천)
            views.setTextColor(dutyResId, Color.parseColor("#666666"))
          } else {
            views.setTextViewText(dutyResId, "")
            views.setViewVisibility(dutyResId, View.GONE)
          }

        } else {
          // 달력 범위 밖의 칸들은 숨기거나 빈칸 처리
          views.setTextViewText(dayResId, "")
          views.setTextViewText(dutyResId, "")
          views.setViewVisibility(dayResId, View.INVISIBLE)
          views.setViewVisibility(dutyResId, View.GONE)
        }
      }

      appWidgetManager.updateAppWidget(appWidgetId, views)
    }
  }
}
