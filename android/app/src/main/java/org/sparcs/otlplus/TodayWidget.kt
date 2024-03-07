package org.sparcs.otlplus

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import java.util.Calendar
import android.widget.RemoteViews

/**
 * Implementation of App Widget functionality.
 */
class TodayWidget : AppWidgetProvider() {
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
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
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
    val dottedItem = RemoteViews(context.packageName, R.layout.today_dotted_time_item)
    for (time in startHour..endHour) {
        val solidItem = RemoteViews(context.packageName, R.layout.today_solid_time_item)
        solidItem.setTextViewText(R.id.time, (if (time > 12) time - 12 else time).toString())
        views.addView(R.id.todayTimetable, solidItem)
        if (time != endHour) views.addView(R.id.todayTimetable, dottedItem)
    }

    // Set time indicator
    fun getMargin(hour: Int, minute: Int): Double =
        startMargin + (hour - startHour + minute / 60.0) * hourMargin

    fun getOffset(hour: Int, minute: Int): Double =
        ((hour + minute / 60.0).coerceIn(minHour, maxHour) - minHour) * hourMargin

    val calendar = Calendar.getInstance()
    val hour = calendar.get(Calendar.HOUR_OF_DAY)
    val minute = calendar.get(Calendar.MINUTE)
    val margin = getMargin(hour, minute)
    val offset = getOffset(hour, minute)

    views.setViewPadding(R.id.todayTimetable, (itemMargin - offset).toInt(), 0, 0, 0)
    views.setViewPadding(R.id.timeIndicatorContainer, (margin - offset).toInt(), 0, 0, 0)

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}