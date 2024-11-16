package org.sparcs.otlplus.api

import org.json.JSONArray
import org.json.JSONObject

class TimetableData(jsonString: String) {
    var lectures: List<Lecture> = listOf()

    init {
        try {
            val jsonObject = JSONObject(jsonString)
            val myTimetableLectures = jsonObject.getJSONArray("my_timetable_lectures")

            lectures = (0 until myTimetableLectures.length()).mapNotNull { index ->
                val lectureJsonObject = myTimetableLectures.getJSONObject(index)
                if (lectureJsonObject.getInt("year") != 2024 || lectureJsonObject.getInt("semester") != 3) {
                    null
                } else {
                    Lecture(
                        name = lectureJsonObject.getString("title"),
                        timeBlocks = toTimeBlocks(
                            lectureJsonObject.getJSONArray("classtimes")
                        ),
                        place = lectureJsonObject.getJSONArray("classtimes")
                            .getJSONObject(0)
                            .getString("classroom_short"),
                        professor = lectureJsonObject.getJSONArray("professors")
                            .getJSONObject(0)
                            .getString("name"),
                        course = lectureJsonObject.getInt("id")
                    )
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun toTimeBlocks(classTimes: JSONArray): List<TimeBlock> =
        (0 until classTimes.length()).map { index ->
            val date = classTimes.getJSONObject(index).getInt("day")
            val begin = classTimes.getJSONObject(index).getInt("begin")
            val end = classTimes.getJSONObject(index).getInt("end")

            TimeBlock(
                weekday = when (date) {
                    1 -> WeekDays.Mon
                    2 -> WeekDays.Tue
                    3 -> WeekDays.Wed
                    4 -> WeekDays.Thu
                    5 -> WeekDays.Fri
                    else -> WeekDays.Undef
                },
                start = LocalTime(
                    hours = begin / 60,
                    minutes = begin % 60
                ),
                end = LocalTime(
                    hours = end / 60,
                    minutes = end % 60
                )
            )
        }
}