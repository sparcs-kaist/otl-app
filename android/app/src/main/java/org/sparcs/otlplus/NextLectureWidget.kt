package org.sparcs.otlplus

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import org.sparcs.otlplus.api.NextLectureData

/**
 * Implementation of App Widget functionality.
 */

class NextLectureWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateNextLectureWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

internal fun updateNextLectureWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    // Construct the RemoteViews object
    RemoteViews(context.packageName, R.layout.next_lecture_widget).let {
        it.setTextViewText(R.id.nextLectureDate, NextLectureData.nextLectureDate)
        it.setTextViewText(R.id.nextLectureName, NextLectureData.nextLectureName)
        it.setTextViewText(R.id.nextLecturePlace, NextLectureData.nextLecturePlace)
        it.setTextViewText(R.id.nextLectureProfessor, NextLectureData.nextLectureProfessor)
        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, it)
    }
}