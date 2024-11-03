package org.sparcs.otlplus

import android.annotation.SuppressLint
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.util.TypedValue
import android.widget.RemoteViews
import org.sparcs.otlplus.api.Lecture
import org.sparcs.otlplus.api.LocalTime
import org.sparcs.otlplus.api.TimetableData
import org.sparcs.otlplus.api.WeekDays
import org.sparcs.otlplus.constants.BlockColor

val timeTableColumns = listOf(
    R.id.time_table_column_1,
    R.id.time_table_column_2,
    R.id.time_table_column_3,
    R.id.time_table_column_4,
    R.id.time_table_column_5,
)

data class TimeTableElement(
    val length: Float,
    val lecture: Lecture?
)

/**
 * Implementation of App Widget functionality.
 */
class TimetableWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateTimetableWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

@SuppressLint("NewApi")
internal fun updateTimetableWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val views = RemoteViews(context.packageName, R.layout.timetable_widget)

    for (timetableColumn in timeTableColumns) {
        views.removeAllViews(timetableColumn)
    }

    val weekTimetable = createTimeTable(TimetableData.lectures)

    for ((weekday, dayTimetable) in weekTimetable.withIndex()) {
        for (timeTableElement in dayTimetable) {
            val blockView = when(timeTableElement.lecture) {
                null -> RemoteViews(context.packageName, R.layout.blank_view)
                else -> RemoteViews(context.packageName, BlockColor.getLayout(timeTableElement.lecture)).apply {
                    setTextViewText(R.id.timetable_block_lecture_name, timeTableElement.lecture.name)
                }
            }

            blockView.setViewLayoutHeight(
                R.id.timetable_block_root,
                timeTableElement.length * 36,
                TypedValue.COMPLEX_UNIT_DIP)

            views.addView(timeTableColumns[weekday], blockView)
        }
    }

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}

fun createTimeTable(lectures: List<Lecture>): List<List<TimeTableElement>> {
    val timetable = List(5) { mutableListOf<TimeTableElement>() }

    for (dayIndex in WeekDays.entries.toTypedArray().indices) {
        val day = WeekDays.entries[dayIndex]

        val dailyLectures = lectures.flatMap { lecture ->
            lecture.timeBlocks.filter { it.weekday == day }.map { it to lecture }
        }.sortedBy { it.first.start.hoursFloat }

        var currentTime = LocalTime(9, 0)

        for ((timeBlock, lecture) in dailyLectures) {
            if (timeBlock.start.hoursFloat > currentTime.hoursFloat) {
                val freeTimeLength = timeBlock.start.hoursFloat - currentTime.hoursFloat
                timetable[dayIndex].add(TimeTableElement(freeTimeLength, null))
            }
            val lectureLength = timeBlock.end.hoursFloat - timeBlock.start.hoursFloat
            timetable[dayIndex].add(TimeTableElement(lectureLength, lecture))
            currentTime = timeBlock.end
        }
    }

    return timetable
}
