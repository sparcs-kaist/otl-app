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
                if (entry.timetableData != nil) {
                    Text("\(getPlace(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date)) \(getName(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))")
                } else {
                    Text(LocalizedStringKey("nextclasswidget.nodata"))
                }
            }
            
        default:
            Text("Not Implemented")
        }
    }
    
    func getNextClass(timetable: Timetable, date: Date) -> (Int, Lecture) {
        var lecture: Lecture = timetable.lectures[0]
        var begin = 1440
        var index = 0
        
        let calendar = Calendar.current
        let day = getDayWithWeekDay(weekday: calendar.component(.weekday, from: date))
        var minutes = calendar.component(.minute, from: date) + calendar.component(.hour, from: date) * 60
        
        var lectures: [(Int, Lecture)] = getLecturesForDay(timetable: timetable, day: day)
        
        for (i, l) in lectures {
            if l.classtimes[i].begin >= minutes && begin >= l.classtimes[i].begin {
                begin = l.classtimes[i].begin
                index = i
                lecture = l
            }
        }
        
        if begin == 1440 {
            var tmrDate = calendar.date(byAdding: .day, value: 1, to: date)!
            lectures = getLecturesForDay(timetable: timetable, day: getDayWithWeekDay(weekday: calendar.component(.weekday, from: tmrDate)))
            minutes = 0
            
            while lectures.count == 0 {
                tmrDate = calendar.date(byAdding: .day, value: 1, to: tmrDate)!
                lectures = getLecturesForDay(timetable: timetable, day: getDayWithWeekDay(weekday: calendar.component(.weekday, from: tmrDate)))
            }
            
            for (i, l) in lectures {
                if l.classtimes[i].begin >= minutes && begin >= l.classtimes[i].begin {
                    begin = l.classtimes[i].begin
                    index = i
                    lecture = l
                }
            }
        }
        
        return (index, lecture)
    }
    
    func getName(timetable: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetable, date: date)
        let lecture: Lecture = c.1
        
        return NSLocale.current.language.languageCode?.identifier == "en" ? lecture.common_title_en : lecture.common_title
    }
    
    func getPlace(timetable: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetable, date: date)
        let index = c.0
        let lecture: Lecture = c.1
        
        return NSLocale.current.language.languageCode?.identifier == "en" ? lecture.classtimes[index].classroom_short_en : lecture.classtimes[index].classroom_short
    }
}


@available(iOSApplicationExtension 16.0, *)
struct LocationInlineAccessory: Widget {
    let kind: String = "LocationInlineAccessory"
    private let title: LocalizedStringKey = "locationinlineaccessory.title"
    private let description: LocalizedStringKey = "locationinlineaccessory.description"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            LocationInlineAccessoryEntryView(entry: entry)
        }
        .configurationDisplayName(title)
        .description(description)
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
