package org.sparcs.otlplus

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.view.View
import java.util.Calendar
import android.widget.RemoteViews
import kotlin.math.roundToInt

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
        val pendingIntent =
            PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)

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
        val pendingIntent =
            PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
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
    val hourMargin = solidWidth + dottedWidth + itemMargin * 2
    val startMargin = itemMargin + solidWidth / 2.0 - indicatorWidth / 2.0

    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.today_widget)

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

    val calendar = Calendar.getInstance()
    val hour = calendar.get(Calendar.HOUR_OF_DAY)
    val minute = calendar.get(Calendar.MINUTE)
    val visibility = isVisible(hour, minute)

    if (visibility) {
        val margin = getMargin(hour, minute)
        val offset = getOffset(hour, minute)

        views.setViewPadding(R.id.todayTimetable, (itemMargin - offset).roundToInt(), 0, 0, 0)
        views.setViewVisibility(R.id.timeIndicator, View.VISIBLE)
        views.setViewPadding(R.id.timeIndicatorContainer, (margin - offset).roundToInt(), 0, 0, 0)
    } else {
        views.setViewPadding(R.id.todayTimetable, itemMargin, 0, 0, 0)
        views.setViewVisibility(R.id.timeIndicator, View.INVISIBLE)
    }

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}