package org.sparcs.otlplus

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.os.Bundle
import android.widget.RemoteViews
import org.sparcs.otlplus.api.Data

/**
 * Implementation of App Widget functionality.
 */

enum class WidgetType {
    NextLecture,
    Timeline,
    Timetable,
}

class TimeTableWidget : AppWidgetProvider() {
    private var widgetType = WidgetType.NextLecture

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        when (widgetType) {
            WidgetType.NextLecture -> updateNextLecture(context, appWidgetManager, appWidgetId)
            WidgetType.Timeline -> updateTimeLine(context, appWidgetManager, appWidgetId)
            WidgetType.Timetable -> updateTimeLine(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context?,
        appWidgetManager: AppWidgetManager?,
        appWidgetId: Int,
        newOptions: Bundle?
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)

        val minWidth = newOptions?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH) ?: 0
        val minHeight = newOptions?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT) ?: 0

        widgetType = when {
            minWidth <= 200 -> WidgetType.NextLecture
            minHeight > 220 -> WidgetType.Timetable
            else -> WidgetType.Timeline
        }

        if (context != null && appWidgetManager != null)
            updateWidget(context, appWidgetManager, appWidgetId)
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

internal fun updateNextLecture(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    // Construct the RemoteViews object
    RemoteViews(context.packageName, R.layout.next_lecture_widget).let {
        it.setTextViewText(R.id.nextLectureDate, Data.nextLectureDate)
        it.setTextViewText(R.id.nextLectureName, Data.nextLectureName)
        it.setTextViewText(R.id.nextLecturePlace, Data.nextLecturePlace)
        it.setTextViewText(R.id.nextLectureProfessor, Data.nextLectureProfessor)
        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, it)
    }
}

internal fun updateTimeLine(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    RemoteViews(context.packageName, R.layout.next_lecture_widget).let {
        it.setTextViewText(R.id.nextLecture, "타임라인입니다.")
        it.setTextViewText(R.id.nextLectureDate, Data.nextLectureDate)
        it.setTextViewText(R.id.nextLectureName, Data.nextLectureName)
        it.setTextViewText(R.id.nextLecturePlace, Data.nextLecturePlace)
        it.setTextViewText(R.id.nextLectureProfessor, Data.nextLectureProfessor)
        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, it)
    }
}