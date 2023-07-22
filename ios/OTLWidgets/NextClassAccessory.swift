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
                VStack(alignment: .center, spacing: 1) {
                    Image("sparcs")
                        .resizable()
//                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(height: 14)
                    Text("12:00")
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    Text("오전")
                        .font(.system(size: 9))
                        .fontWeight(.medium)
                }
            }
        case .accessoryRectangular:
            ZStack {
                AccessoryWidgetBackground()
                Text("Hello")
            }
            
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
