//
//  NextClassAccessory.swift
//  OTLWidgetsExtension
//
//  Created by Soongyu Kwon on 22/07/2023.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

@available(iOSApplicationExtension 16.0, *)
struct NextClassAccessoryEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                VStack {
                    Image(systemName: "tablecells")
                        .font(.caption2)
                        .widgetAccentable()
                    Text("12:00")
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    Text("오전")
                        .font(.system(size: 9))
                        .fontWeight(.medium)
                }
            }
        case .accessoryRectangular:
            HStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 4) {
                        Circle()
                            .frame(width: 12, height: 12)
                        Text("10:30 - 12:30")
                            .font(.headline)
                    }.offset(y: 7)
                        .widgetAccentable()
                    Text("프로그래밍기초")
                        .font(.headline)
                        .widgetAccentable()
                    Text("E11 창의학습관 101호")
                        .foregroundColor(.gray)
                }
                Spacer()
            }.offset(y: -3)
            
        default:
            Text("Not Implemented")
        }
    }
}


@available(iOSApplicationExtension 16.0, *)
struct NextClassAccessory: Widget {
    let kind: String = "NextClassAccessory"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NextClassAccessoryEntryView(entry: entry)
        }
        .configurationDisplayName("다음 수업")
        .description("다음 수업을 확인합니다.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
    }
}

@available(iOSApplicationExtension 16.0, *)
struct NextClassAccessoryPreviews: PreviewProvider {
    static var previews: some View {
        NextClassAccessoryEntryView(entry: WidgetEntry(date: Date(), timetableData: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Circular")
        NextClassAccessoryEntryView(entry: WidgetEntry(date: Date(), timetableData: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Rectangular")
    }
}
