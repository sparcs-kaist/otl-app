package org.sparcs.otlplus.constants

import org.sparcs.otlplus.R
import org.sparcs.otlplus.api.Lecture

object BlockColor {
    val blockColorsLayout = arrayOf(
        R.layout.timetable_block0,
        R.layout.timetable_block1,
        R.layout.timetable_block2,
        R.layout.timetable_block3,
        R.layout.timetable_block4,
        R.layout.timetable_block5,
        R.layout.timetable_block6,
        R.layout.timetable_block7,
        R.layout.timetable_block8,
        R.layout.timetable_block9,
        R.layout.timetable_block10,
        R.layout.timetable_block11,
        R.layout.timetable_block12,
        R.layout.timetable_block13,
        R.layout.timetable_block14,
        R.layout.timetable_block15,
    )

    fun getLayout(lecture: Lecture) = blockColorsLayout[lecture.course % 16]
}