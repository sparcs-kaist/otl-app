//
//  next_class_widget.swift
//  next class widget
//
//  Created by Soongyu Kwon on 28/03/2023.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Timetable: Decodable, Hashable {
    let id: Int
    let lectures: [Lecture]
}

struct Lecture: Decodable, Hashable {
    let id: Int
    let title: String
    let title_en: String
    let course: Int
    let old_code: String
    let class_no: String
    let year: Int
    let semester: Int
    let code: String
    let department: Int
    let department_code: String
    let department_name: String
    let department_name_en: String
    let type: String
    let type_en: String
    let limit: Int
    let num_people: Int
    let is_english: Bool
    let credit: Int
    let credit_au: Int
    let common_title: String
    let common_title_en: String
    let class_title: String
    let class_title_en: String
    let review_total_weight: Double
    let grade: Double
    let speech: Double
    let professors: [Professor]
    let classtimes: [Classtime]
    let examtimes: [Examtime]
}

struct Professor: Decodable, Hashable {
    let name: String
    let name_en: String
    let professor_id: Int
    let review_total_weight: Double
}

struct Classtime: Decodable, Hashable {
    let building_code: String
    let classroom: String
    let classroom_en: String
    let classroom_short: String
    let classroom_short_en: String
    let room_name: String
    let day: Int
    let begin: Int
    let end: Int
}

struct Examtime: Decodable, Hashable {
    let str: String
    let str_en: String
    let day: Int
    let begin: Int
    let end: Int
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), timetableData: nil, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date(), timetableData: nil, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let sharedDefaults = UserDefaults.init(suiteName: "group.org.sparcs.otlplus")
        
        let data = try? JSONDecoder().decode([Timetable].self, from: (sharedDefaults?.string(forKey: "widgetData")?.data(using: .utf8)) ?? Data())
        let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: Date())!
        let entry = WidgetEntry(date: entryDate, timetableData: data, configuration: configuration)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let timetableData: [Timetable]?
    let configuration: ConfigurationIntent
}

struct next_class_widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color(red: 249.0/255, green: 240.0/255, blue: 240.0/255)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("다음 강의")
                            .font(.custom("NotoSansKR-Bold", size: 12))
                            .foregroundColor(Color(red: 229.0/255, green: 76.0/255, blue: 100.0/255))
                        Text(getNextClassTimeLeft(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
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
                        .fill(getNextClassColour(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                        .frame(width: 2, height: 60)
                        .cornerRadius(1)

                    VStack(alignment: .leading) {
                        Text(getNextClassName(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                            .font(.custom("NotoSansKR-Bold", size: 16))
                            .minimumScaleFactor(0.5)
                            .lineLimit(2)
                        Text(getNextClassPlace(timetabe: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                            .font(.custom("NotoSansKR-Regular", size: 12))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        Text(getNextClassTime(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
                            .font(.custom("NotoSansKR-Medium", size: 12))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }.padding(.all, 16)
        }
    }
    
    func getNextClass(timetable: Timetable, date: Date) -> (Int, Lecture) {
        var lecture: Lecture = timetable.lectures[0]
        var lday = -5
        var begin = 10000
        var index = 0
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date) - 2
        let minutes = calendar.component(.minute, from: date) + calendar.component(.hour, from: date) * 60
        
        for l in timetable.lectures {
            for i in 0..<l.classtimes.count {
                let c = l.classtimes[i]
                if c.day == day && c.begin >= minutes && begin >= c.begin {
                    lday = c.day
                    begin = c.begin
                    index = i
                    lecture = l
                }
            }
        }
        
        if lday == -5 {
            for l in timetable.lectures {
                for i in 0..<l.classtimes.count {
                    let c = l.classtimes[i]
                    if c.day > day && begin >= c.begin {
                        lday = c.day
                        begin = c.begin
                        index = i
                        lecture = l
                    }
                }
            }
        }
        
        if lday == -5 {
            lday = 10
            for l in timetable.lectures {
                for i in 0..<l.classtimes.count {
                    let c = l.classtimes[i]
                    if lday >= c.day && begin >= c.begin {
                        lday = c.day
                        begin = c.begin
                        index = i
                        lecture = l
                    }
                }
            }
        }
        
        return (index, lecture)
    }
    
    func getNextClassName(timetable: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetable, date: date)
        let lecture: Lecture = c.1
        
        return lecture.common_title
    }
    
    func getNextClassPlace(timetabe: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetabe, date: date)
        let index = c.0
        let lecture: Lecture = c.1
        
        return lecture.classtimes[index].classroom
    }
    
    func getNextClassTime(timetable: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetable, date: date)
        let index = c.0
        let lecture: Lecture = c.1
        let begin = lecture.classtimes[index].begin
        let end = lecture.classtimes[index].end
        
        return String(format:"%02d:%02d-%02d:%02d", begin/60, begin%60, end/60, end%60)
    }
    
    func getNextClassTimeLeft(timetable: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetable, date: date)
        let index = c.0
        let lecture: Lecture = c.1
        
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date) - 2
        let minutes = calendar.component(.minute, from: date) + calendar.component(.hour, from: date) * 60
        
        let begin = lecture.classtimes[index].begin
        let lday = lecture.classtimes[index].day
        
        if lday == day {
            let left = begin - minutes
            if left / 60 == 0 {
                return "\(left)분 후"
            } else {
                return "\(left/60)시간 \(left%60)분 후"
            }
        } else if lday == day+1 {
            return "내일"
        } else if lday > day+1 {
            return "이번주"
        } else {
            return "다음주"
        }
    }
    
    func getNextClassColour(timetable: Timetable, date: Date) -> Color {
        let c = getNextClass(timetable: timetable, date: date)
        let course = c.1.course

        let colours = [
            [242.0, 206.0, 206.0],
            [244.0, 179.0, 174.0],
            [242.0, 188.0, 160.0],
            [240.0, 211.0, 171.0],
            [241.0, 225.0, 169.0],
            [244.0, 242.0, 179.0],
            [219.0, 244.0, 190.0],
            [190.0, 237.0, 215.0],
            [183.0, 226.0, 222.0],
            [201.0, 234.0, 244.0],
            [180.0, 211.0, 237.0],
            [185.0, 197.0, 237.0],
            [204.0, 198.0, 237.0],
            [216.0, 193.0, 240.0],
            [235.0, 202.0, 239.0],
            [244.0, 186.0, 219.0]
        ]
        
        return Color(red: Double(colours[course % 16][0]/255), green:Double(colours[course % 16][1]/255), blue:Double(colours[course % 16][2]/255))
    }
}

struct next_class_widget: Widget {
    let kind: String = "next_class_widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            next_class_widgetEntryView(entry: entry)
        }
        .configurationDisplayName("다음 수업")
        .description("다음에 시작할 수업을 확인합니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct next_class_widget_Previews: PreviewProvider {
    static var previews: some View {
        next_class_widgetEntryView(entry: WidgetEntry(date: Date(), timetableData: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
