//
//  LocationInlineAccessory.swift
//  OTLWidgetsExtension
//
//  Created by Soongyu Kwon on 28/07/2023.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

@available(iOSApplicationExtension 16.0, *)
struct LocationInlineAccessoryEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .accessoryInline:
            HStack {
                Image(systemName: "tablecells")
                Text("(E11 303) 프로그래밍기초")
            }
            
        default:
            Text("Not Implemented")
        }
    }
}


@available(iOSApplicationExtension 16.0, *)
struct LocationInlineAccessory: Widget {
    let kind: String = "LocationInlineAccessory"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            LocationInlineAccessoryEntryView(entry: entry)
        }
        .configurationDisplayName("다음 수업과 장소")
        .description("다음 수업과 장소를 확인합니다.")
        .supportedFamilies([.accessoryInline])
    }
}

@available(iOSApplicationExtension 16.0, *)
struct LocationInlineAccessoryPreviews: PreviewProvider {
    static var previews: some View {
        LocationInlineAccessoryEntryView(entry: WidgetEntry(date: Date(), timetableData: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
    }
}
