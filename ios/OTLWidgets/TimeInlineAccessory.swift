//
//  TimeInlineAccessory.swift
//  OTLWidgetsExtension
//
//  Created by Soongyu Kwon on 28/07/2023.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

@available(iOSApplicationExtension 16.0, *)
struct TimeInlineAccessoryEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .accessoryInline:
            HStack {
                Image(systemName: "tablecells")
                Text("10:30 프로그래밍기초")
            }
            
        default:
            Text("Not Implemented")
        }
    }
}


@available(iOSApplicationExtension 16.0, *)
struct TimeInlineAccessory: Widget {
    let kind: String = "TimeInlineAccessory"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TimeInlineAccessoryEntryView(entry: entry)
        }
        .configurationDisplayName("다음 수업과 시간")
        .description("다음 수업과 시간을 확인합니다.")
        .supportedFamilies([.accessoryInline])
    }
}

@available(iOSApplicationExtension 16.0, *)
struct TimeInlineAccessoryPreviews: PreviewProvider {
    static var previews: some View {
        TimeInlineAccessoryEntryView(entry: WidgetEntry(date: Date(), timetableData: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
    }
}
