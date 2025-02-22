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
                if (lectureJsonObject.getInt("year") != 2025 || lectureJsonObject.getInt("semester") != 1) {
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
//            e.printStackTrace()
        }
    }

    private fun toTimeBlocks(classTimes: JSONArray): List<TimeBlock> =
        (0 until classTimes.length()).map { index ->
            val date = classTimes.getJSONObject(index).getInt("day")
            val begin = classTimes.getJSONObject(index).getInt("begin")
            val end = classTimes.getJSONObject(index).getInt("end")

            TimeBlock(
                weekday = when (date) {
                    0 -> WeekDays.Mon
                    1 -> WeekDays.Tue
                    2 -> WeekDays.Wed
                    3 -> WeekDays.Thu
                    4 -> WeekDays.Fri
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