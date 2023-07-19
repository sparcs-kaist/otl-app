//
//  NextClassWidget.swift
//  OTLWidgetsExtension
//
//  Created by Soongyu Kwon on 28/03/2023.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    typealias Entry = WidgetEntry
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), timetableData: nil, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let sharedDefaults = UserDefaults.init(suiteName: "group.org.sparcs.otlplus")
        
        let data = try? JSONDecoder().decode([Timetable].self, from: (sharedDefaults?.string(forKey: "widgetData")?.data(using: .utf8)) ?? Data())

        let entryDate = Date()
        let entry = WidgetEntry(date: entryDate, timetableData: data, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        var entries: [WidgetEntry] = [WidgetEntry]()
        let sharedDefaults = UserDefaults.init(suiteName: "group.org.sparcs.otlplus")
        let data = try? JSONDecoder().decode([Timetable].self, from: (sharedDefaults?.string(forKey: "widgetData")?.data(using: .utf8)) ?? Data())
        
        let currentDate = Date()
        for minutesOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minutesOffset*15, to: currentDate)!
            let entry = WidgetEntry(date: entryDate, timetableData: data, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}



struct WidgetEntry: TimelineEntry {
    let date: Date
    let timetableData: [Timetable]?
    let configuration: ConfigurationIntent
}

struct NextClassWidgetEntryView : View {
    @Environment(\.colorScheme) var colorScheme
    
    var entry: Provider.Entry
    
    var widgetBackground: some View {
        colorScheme == .dark ? Color(red: 51.0/255, green: 51.0/255, blue: 51.0/255) : Color(red: 249.0/255, green: 240.0/255, blue: 240.0/255)
    }

    var body: some View {
        if (entry.timetableData != nil && entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0].lectures.count > 0) {
            ZStack(alignment: .leading) {
                widgetBackground
                VStack(alignment: .leading) {
                    Text("다음 강의")
                        .font(.custom("NotoSansKR-Bold", size: 12))
                        .foregroundColor(Color(red: 229.0/255, green: 76.0/255, blue: 100.0/255))
                    Text(getTimeLeft(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                        .font(.custom("NotoSansKR-Bold", size: 20))
                        .offset(y: -2)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack {
                        Circle()
                            .fill(getColour(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                            .frame(width: 12, height: 12)
                        Text(getName(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                            .font(.custom("NotoSansKR-Bold", size: 16))
                            .minimumScaleFactor(0.5)
                            .lineLimit(2)
                    }.offset(y: 8)
                    Text(getPlace(timetabe: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                        .font(.custom("NotoSansKR-Regular", size: 12))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    Text(getProfessor(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                        .font(.custom("NotoSansKR-Medium", size: 12))
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.gray)
                }.padding()
            }
        } else {
            ZStack(alignment: .leading) {
                widgetBackground
                VStack(alignment: .leading) {
                    Text("다음 강의")
                        .font(.custom("NotoSansKR-Bold", size: 12))
                        .foregroundColor(Color(red: 229.0/255, green: 76.0/255, blue: 100.0/255))
                    Text("정보 없음")
                        .font(.custom("NotoSansKR-Bold", size: 20))
                        .offset(y: -2)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack {
                        Circle()
                            .fill(getColourForCourse(course: 1))
                            .frame(width: 12, height: 12)
                        Text("정보 없음")
                            .font(.custom("NotoSansKR-Bold", size: 16))
                            .minimumScaleFactor(0.5)
                            .lineLimit(2)
                    }.offset(y: 8)
                    Text("정보 없음")
                        .font(.custom("NotoSansKR-Regular", size: 12))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    Text("정보 없음")
                        .font(.custom("NotoSansKR-Medium", size: 12))
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.gray)
                }.padding()
                if (entry.timetableData == nil) {
                    ZStack {
                        Color.clear
                            .background(.ultraThinMaterial)
                        VStack {
                            Image("lock")
                                .resizable()
                            .frame(width: 44, height: 44)
                            Text("로그인하러 가기")
                                .font(.custom("NotoSansKR-Bold", size: 12))
                                .padding(.horizontal, 10.0)
                                .padding(.vertical, 4)
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 30).foregroundColor(Color(red: 229.0/255, green: 76.0/255, blue: 100.0/255)))
                        }
                    }
                }
            }
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
        
        return lecture.common_title
    }
    
    func getProfessor(timetable: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetable, date: date)
        let lecture: Lecture = c.1
        
        return "\(lecture.professors[0].name) 교수님"
    }
    
    func getPlace(timetabe: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetabe, date: date)
        let index = c.0
        let lecture: Lecture = c.1
        
        return lecture.classtimes[index].classroom
    }
    
    func getTimeLeft(timetable: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetable, date: date)
        let index = c.0
        let lecture: Lecture = c.1
        
        let calendar = Calendar.current
        let day = getDayWithWeekDay(weekday: calendar.component(.weekday, from: date))
        
        
        let begin = lecture.classtimes[index].begin
        let lday = lecture.classtimes[index].day
        
        if lday == day {
            return String(format:"오늘 %02d:%02d", begin/60, begin%60)
        } else if lday == day+1 {
            return String(format:"내일 %02d:%02d", begin/60, begin%60)
        } else if lday > day+1 {
            return String(format:"\(getDayInString(day: lday))요일 %02d:%02d", begin/60, begin%60)
        } else {
            return "다음주 \(getDayInString(day: lday))요일"
        }
    }
    
    func getColour(timetable: Timetable, date: Date) -> Color {
        let c = getNextClass(timetable: timetable, date: date)
        let course = c.1.course
        
        return getColourForCourse(course: course)
    }
}

struct NextClassWidget: Widget {
    let kind: String = "NextClassWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NextClassWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("다음 수업")
        .description("다음에 시작할 수업을 확인합니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct NextClassWidgetPreviews: PreviewProvider {
    static var previews: some View {
        NextClassWidgetEntryView(entry: WidgetEntry(date: Date(), timetableData: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
