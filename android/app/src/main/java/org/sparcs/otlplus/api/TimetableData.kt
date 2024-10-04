package org.sparcs.otlplus.api

object TimetableData {
    val lectures: List<Lecture>
        get() = listOf(
            Lecture(
                name = "프로그래밍 기초",
                place = "(E11)창의학습관 308",
                professor = "김교수",
                timeBlocks = listOf(
                    TimeBlock(
                        weekday = WeekDays.Mon,
                        start = LocalTime(9, 0),
                        end = LocalTime(12, 0),
                    ),
                    TimeBlock(
                        weekday = WeekDays.Wed,
                        start = LocalTime(10, 30),
                        end = LocalTime(12, 0),
                    ),
                )
            ),
            Lecture(
                name = "지속가능 사회 인프라 시스템과 환경의 이해",
                place = "(E11) 창의학습관 208",
                professor = "김교수",
                timeBlocks = listOf(
                    TimeBlock(
                        weekday = WeekDays.Mon,
                        start = LocalTime(16, 0),
                        end = LocalTime(17, 30),
                    ),
                    TimeBlock(
                        weekday = WeekDays.Wed,
                        start = LocalTime(16, 0),
                        end = LocalTime(17, 30),
                    ),
                )
            )
        )
}