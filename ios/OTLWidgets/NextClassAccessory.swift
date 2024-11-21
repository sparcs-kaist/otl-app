//
//  NextClassAccessory.swift
//  OTLWidgetsExtension
//
//  Created by Soongyu Kwon on 22/07/2023.
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
                if (entry.timetableData != nil && entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0].lectures.count > 0) {
                    VStack {
                        Image(systemName: "tablecells")
                            .font(.caption2)
                            .widgetAccentable()
                        Text(getBeginInTwelveHour(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date).0)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        Text(getBeginInTwelveHour(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date).1)
                            .font(.system(size: 9))
                            .fontWeight(.medium)
                    }
                } else {
                    VStack {
                        Image(systemName: "tablecells")
                            .font(.caption2)
                            .widgetAccentable()
                        Text(LocalizedStringKey("nextclasswidget.nodata"))
                            .font(.system(size: 10))
                            .fontWeight(.medium)
                            .padding(.top, 2)
                        Text("")
                            .font(.system(size: 9))
                            .fontWeight(.medium)
                    }
                }
            }
        case .accessoryRectangular:
            HStack {
                if (entry.timetableData != nil && entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0].lectures.count > 0) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center, spacing: 4) {
                            Circle()
                                .frame(width: 12, height: 12)
                            Text("\(getBegin(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date)) - \(getEnd(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))")
                                .font(.headline)
                        }.offset(y: 7)
                            .widgetAccentable()
                        Text(getName(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                            .font(.headline)
                            .widgetAccentable()
                        Text(getPlace(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                            .foregroundColor(.gray)
                    }
                } else {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center, spacing: 4) {
                            Circle()
                                .frame(width: 12, height: 12)
                            Text(LocalizedStringKey("nextclasswidget.nodata"))
                                .font(.headline)
                        }.offset(y: 7)
                            .widgetAccentable()
                        Text("")
                            .font(.headline)
                            .widgetAccentable()
                        Text("")
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
            }.offset(y: -3)
            
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
    
    func getBeginInTwelveHour(timetable: Timetable, date: Date) -> (String, String) {
        let c = getNextClass(timetable: timetable, date: date)
        let index = c.0
        let lecture: Lecture = c.1
        
        var hour = (lecture.classtimes[index].begin >= 720) ? (lecture.classtimes[index].begin-720)/60 : lecture.classtimes[index].begin/60
        hour = (hour == 0) ? 12 : hour
        
        var am: String {
            return NSLocale.current.language.languageCode?.identifier == "en" ? "AM" : "오전"
        }
        
        var pm: String {
            return NSLocale.current.language.languageCode?.identifier == "en" ? "PM" : "오후"
        }
        
        let apm = (lecture.classtimes[index].begin >= 720) ? pm : am
        
        return (String(format:"%02d:%02d", hour, lecture.classtimes[index].begin%60), apm)
    }
    
    func getName(timetable: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetable, date: date)
        let lecture: Lecture = c.1
        
        return NSLocale.current.language.languageCode?.identifier == "en" ? lecture.common_title_en : lecture.common_title
    }
    
    func getBegin(timetable: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetable, date: date)
        let index = c.0
        let lecture: Lecture = c.1
        
        return String(format:"%02d:%02d", lecture.classtimes[index].begin/60, lecture.classtimes[index].begin%60)
    }
    
    func getPlace(timetable: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetable, date: date)
        let index = c.0
        let lecture: Lecture = c.1
        
        return NSLocale.current.language.languageCode?.identifier == "en" ? lecture.classtimes[index].classroom_short_en : lecture.classtimes[index].classroom
    }
    
    func getEnd(timetable: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetable, date: date)
        let index = c.0
        let lecture: Lecture = c.1
        
        return String(format:"%02d:%02d", lecture.classtimes[index].end/60, lecture.classtimes[index].end%60)
    }
}


@available(iOSApplicationExtension 16.0, *)
struct NextClassAccessory: Widget {
    let kind: String = "NextClassAccessory"
    private let title: LocalizedStringKey = "nextclasswidget.title"
    private let description: LocalizedStringKey = "nextclasswidget.description"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NextClassAccessoryEntryView(entry: entry)
        }
        .configurationDisplayName(title)
        .description(description)
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
