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
        WidgetEntry(date: Date(), timetableData: nil, todayLectures: nil, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let sharedDefaults = UserDefaults.init(suiteName: "group.org.sparcs.otlplus")
        
        let data = try? JSONDecoder().decode([Timetable].self, from: (sharedDefaults?.string(forKey: "widgetData")?.data(using: .utf8)) ?? Data())

        let entryDate = Date()
        let entry = WidgetEntry(date: entryDate, timetableData: data, todayLectures: getTodayLectures(timetable: data?[Int(configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entryDate), configuration: configuration)
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
            let entry = WidgetEntry(date: entryDate, timetableData: data, todayLectures: getTodayLectures(timetable: data?[Int(configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entryDate), configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}



struct WidgetEntry: TimelineEntry {
    let date: Date
    let timetableData: [Timetable]?
    let todayLectures: [(Int, Lecture)]?
    let configuration: ConfigurationIntent
}

struct NextClassWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if (entry.timetableData != nil) {
            ZStack {
                Color(red: 249.0/255, green: 240.0/255, blue: 240.0/255)
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("다음 강의")
                                .font(.custom("NotoSansKR-Bold", size: 12))
                                .foregroundColor(Color(red: 229.0/255, green: 76.0/255, blue: 100.0/255))
                            Text(getTimeLeft(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                                .font(.custom("NotoSansKR-Bold", size: 20))
                                .offset(y: -2)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Rectangle()
                            .fill(getColour(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                            .frame(width: 2, height: 60)
                            .cornerRadius(1)

                        VStack(alignment: .leading) {
                            Text(getName(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                                .font(.custom("NotoSansKR-Bold", size: 16))
                                .minimumScaleFactor(0.5)
                                .lineLimit(2)
                            Text(getPlace(timetabe: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                                .font(.custom("NotoSansKR-Regular", size: 12))
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                            Text(getProfessor(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                                .font(.custom("NotoSansKR-Medium", size: 12))
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                }.padding(.all, 16)
            }
        } else {
            ZStack {
                Color(red: 249.0/255, green: 240.0/255, blue: 240.0/255)
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("다음 강의")
                                .font(.custom("NotoSansKR-Bold", size: 12))
                                .foregroundColor(Color(red: 229.0/255, green: 76.0/255, blue: 100.0/255))
                            Text("오류")
                                .font(.custom("NotoSansKR-Bold", size: 20))
                                .offset(y: -2)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Rectangle()
                            .fill(getColourForCourse(course: 1))
                            .frame(width: 2, height: 60)
                            .cornerRadius(1)

                        VStack(alignment: .leading) {
                            Text("로그인해 주세요")
                                .font(.custom("NotoSansKR-Bold", size: 16))
                                .minimumScaleFactor(0.5)
                                .lineLimit(2)
                            Text("시간표 불러오기 실패")
                                .font(.custom("NotoSansKR-Regular", size: 12))
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                            Text("데이터 없음")
                                .font(.custom("NotoSansKR-Medium", size: 12))
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                }.padding(.all, 16)
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
            return String(format:"%s요일 %02d:%02d", getDayInString(day: lday), begin/60, begin%60)
        } else {
            return String(format:"다음주 %s요일", getDayInString(day: lday))
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
        NextClassWidgetEntryView(entry: WidgetEntry(date: Date(), timetableData: nil, todayLectures: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}