package org.sparcs.otlplus

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale
import kotlin.math.roundToInt
import org.json.JSONArray
import org.json.JSONObject

/**
 * Implementation of App Widget functionality.
 */
class TodayWidget : AppWidgetProvider() {
    companion object {
        const val ACTION_UPDATE_WIDGET = "ACTION_UPDATE_WIDGET"
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        super.onReceive(context, intent)

        if (intent?.action == ACTION_UPDATE_WIDGET) {
            context?.let {
                val appWidgetManager = AppWidgetManager.getInstance(it)
                val widget = ComponentName(it, TodayWidget::class.java)
                val appWidgetIds = appWidgetManager.getAppWidgetIds(widget)
                for (appWidgetId in appWidgetIds) {
                    updateTodayWidget(it, appWidgetManager, appWidgetId)
                }
            }
        }
    }

    override fun onUpdate(
        context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateTodayWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
        super.onEnabled(context)
        scheduleAlarm(context)
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
        super.onDisabled(context)
        cancelAlarm(context)
    }

    private fun scheduleAlarm(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, TodayWidget::class.java)
        intent.action = ACTION_UPDATE_WIDGET
        val pendingIntent = PendingIntent.getBroadcast(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )

        // Schedule alarm to update widget every minute
        alarmManager.setRepeating(
            AlarmManager.RTC, System.currentTimeMillis(), 60000, // 1 minute in milliseconds
            pendingIntent
        )
    }

    private fun cancelAlarm(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, TodayWidget::class.java)
        intent.action = ACTION_UPDATE_WIDGET
        val pendingIntent = PendingIntent.getBroadcast(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
        alarmManager.cancel(pendingIntent)
    }
}

internal fun updateTodayWidget(
    context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int
) {
    // Const
    val startHour = 8
    val endHour = 24
    val minHour = startHour + 2.0
    val maxHour = endHour - 3.0
    val solidWidth = context.resources.getDimensionPixelSize(R.dimen.today_solid_time_width)
    val dottedWidth = context.resources.getDimensionPixelSize(R.dimen.today_dotted_time_width)
    val indicatorWidth = context.resources.getDimensionPixelSize(R.dimen.time_indicator_width)
    val itemMargin = context.resources.getDimensionPixelSize(R.dimen.today_time_margin)
    val blockMargin = context.resources.getDimensionPixelSize(R.dimen.block_margin)
    val hourMargin = solidWidth + dottedWidth + itemMargin * 2
    val startMargin = itemMargin + solidWidth / 2.0

    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.today_widget)

    // Check timetable data
    val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

    fun parseDateFromPrefs(key: String): Calendar? {
        val dateString = prefs.getString("flutter.$key", "")
        val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        return try {
            val date = Calendar.getInstance()
            date.time = dateFormat.parse(dateString!!)!!
            date
        } catch (e: Exception) {
            null
        }
    }

    fun parseLecturesFromPrefs(): List<MutableMap<String, Any>> {
        fun parseClasstimesJson(classtimesArray: JSONArray): List<Map<String, Any>> {
            val classtimes = mutableListOf<Map<String, Any>>()
            for (i in 0 until classtimesArray.length()) {
                val classtime = classtimesArray.getJSONObject(i)
                val classtimeMap = mutableMapOf<String, Any>()
                classtimeMap["classroom_short"] = classtime.getString("classroom_short")
                classtimeMap["classroom_short_en"] = classtime.getString("classroom_short_en")
                classtimeMap["day"] = classtime.getInt("day")
                classtimeMap["begin"] = classtime.getInt("begin")
                classtimeMap["end"] = classtime.getInt("end")
                classtimes.add(classtimeMap)
            }
            return classtimes
        }

        fun parseLectureJson(lecture: JSONObject): MutableMap<String, Any> {
            val lectureMap = mutableMapOf<String, Any>()
            lectureMap["title"] = lecture.getString("title")
            lectureMap["title_en"] = lecture.getString("title_en")
            lectureMap["course"] = lecture.getInt("course")
            lectureMap["professors"] = lecture.getString("professors")
            lectureMap["professors_en"] = lecture.getString("professors_en")
            lectureMap["classtimes"] = parseClasstimesJson(lecture.getJSONArray("classtimes"))
            return lectureMap
        }

        val lecturesJson = prefs.getString("flutter.lectures", "[]")
        val lecturesArray = JSONArray(lecturesJson ?: "[]")

        val lectures = mutableListOf<MutableMap<String, Any>>()
        for (i in 0 until lecturesArray.length()) {
            val lecture = lecturesArray.getJSONObject(i)
            val lectureMap = parseLectureJson(lecture)
            lectures.add(lectureMap)
        }
        return lectures
    }

    val semesterBeginning = parseDateFromPrefs("beginning")
    val semesterEnd = parseDateFromPrefs("end")
    val calendar = Calendar.getInstance()

    if (calendar.after(semesterBeginning) && calendar.before(semesterEnd)) {
        Log.d("TodayWidget", "Have data")

        // Add time items
        views.removeAllViews(R.id.todayTimetable)

        val dottedItem = RemoteViews(context.packageName, R.layout.today_dotted_time_item)
        for (time in startHour..endHour) {
            val solidItem = RemoteViews(context.packageName, R.layout.today_solid_time_item)
            solidItem.setTextViewText(R.id.time, (if (time > 12) time - 12 else time).toString())
            views.addView(R.id.todayTimetable, solidItem)
            if (time != endHour) views.addView(R.id.todayTimetable, dottedItem)
        }

        // Set time indicator
        fun isVisible(hour: Int, minute: Int): Boolean = (hour + minute / 60.0).let { time ->
            time > startHour && time < endHour
        }

        fun getMargin(hour: Int, minute: Int): Double =
            startMargin + (hour - startHour + minute / 60.0) * hourMargin

        fun getOffset(hour: Int, minute: Int): Double =
            ((hour + minute / 60.0).coerceIn(minHour, maxHour) - minHour) * hourMargin

        val hour = calendar.get(Calendar.HOUR_OF_DAY)
        val minute = calendar.get(Calendar.MINUTE)
        val visibility = isVisible(hour, minute)
        val offset = getOffset(hour, minute)

        Log.d("TodayWidget", "updated at $hour:$minute")

        if (visibility) {
            val margin = getMargin(hour, minute) - indicatorWidth / 2.0

            views.setViewPadding(R.id.todayTimetable, (itemMargin - offset).roundToInt(), 0, 0, 0)
            views.setViewVisibility(R.id.timeIndicator, View.VISIBLE)
            views.setViewPadding(
                R.id.timeIndicatorContainer, (margin - offset).roundToInt(), 0, 0, 0
            )
        } else {
            views.setViewPadding(R.id.todayTimetable, itemMargin, 0, 0, 0)
            views.setViewVisibility(R.id.timeIndicator, View.INVISIBLE)
        }

        val lectures = parseLecturesFromPrefs()
        val timetable = Array(7) { mutableListOf<Map<String, Any>>() }
        lectures.forEach { lecture ->
            (lecture["classtimes"] as List<*>).forEach { classtime ->
                val day = (classtime as Map<*, *>)["day"] as Int // 0 is monday
                val updatedLecture = lecture.toMutableMap()
                updatedLecture["classroom_short"] = classtime["classroom_short"] as Any
                updatedLecture["classroom_short_en"] = classtime["classroom_short_en"] as Any
                updatedLecture["begin"] = classtime["begin"] as Any
                updatedLecture["end"] = classtime["end"] as Any
                timetable[day].add(updatedLecture)
            }
        }

        // Add lecture blocks
        views.removeAllViews(R.id.todayLectureBlockContainer)

        fun getLayoutId(minute: Int): Int? = when (minute) {
            30 -> R.layout.today_lecture_block_30
            50 -> R.layout.today_lecture_block_50
            60 -> R.layout.today_lecture_block_60
            70 -> R.layout.today_lecture_block_70
            75 -> R.layout.today_lecture_block_75
            90 -> R.layout.today_lecture_block_90
            110 -> R.layout.today_lecture_block_110
            120 -> R.layout.today_lecture_block_120
            150 -> R.layout.today_lecture_block_150
            165 -> R.layout.today_lecture_block_165
            170 -> R.layout.today_lecture_block_170
            180 -> R.layout.today_lecture_block_180
            210 -> R.layout.today_lecture_block_210
            240 -> R.layout.today_lecture_block_240
            300 -> R.layout.today_lecture_block_300
            360 -> R.layout.today_lecture_block_360
            420 -> R.layout.today_lecture_block_420
            480 -> R.layout.today_lecture_block_480
            540 -> R.layout.today_lecture_block_540
            else -> null
        }

        timetable[(calendar.get(Calendar.DAY_OF_WEEK) + 5) % 7].forEach { lecture ->
            val begin = lecture["begin"] as Int
            val end = lecture["end"] as Int
            (getLayoutId(end - begin))?.let { layoutId ->
                val margin = getMargin(begin / 60, begin % 60) + blockMargin
                val lectureBlock = RemoteViews(context.packageName, layoutId)
                lectureBlock.setTextViewText(R.id.lectureTitle, lecture["title"].toString())
                lectureBlock.setTextViewText(
                    R.id.lectureRoom, lecture["classroom_short"].toString()
                )
                lectureBlock.setViewPadding(
                    R.id.todayLectureBlock, (margin - offset).roundToInt(), 0, 0, 0
                )
                views.addView(R.id.todayLectureBlockContainer, lectureBlock)
            }
        }

    } else {
        Log.d("TodayWidget", "Need data")
    }

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}