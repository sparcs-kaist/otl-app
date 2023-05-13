//
//  WeekClassesWidget.swift
//  next class widgetExtension
//
//  Created by Soongyu Kwon on 14/05/2023.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents


struct WeekClassesWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("자러갈래")
    }
}

struct WeekClassesWidget: Widget {
    let kind: String = "WeekClassesWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TodayClassesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("주간 시간표")
        .description("일주일의 모든 수업을 확인합니다.")
        .supportedFamilies([.systemLarge])
    }
}

struct WeekClassesWidgetPreviews: PreviewProvider {
    static var previews: some View {
        WeekClassesWidgetEntryView(entry: WidgetEntry(date: Date(), timetableData: nil, todayLectures: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
