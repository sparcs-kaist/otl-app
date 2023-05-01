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
//        Text(entry.timetableData?[0].lectures[0].common_title ?? "error")
        ZStack {
            Color(red: 249.0/255, green: 240.0/255, blue: 240.0/255)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("다음 강의")
                            .font(.custom("NotoSansKR-Bold", size: 12))
                            .foregroundColor(Color(red: 229.0/255, green: 76.0/255, blue: 100.0/255))
                        Text("10분 후")
                            .font(.custom("NotoSansKR-Bold", size: 20))
                            .offset(y: -2)
                    }
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Rectangle()
                        .fill(Color(red: 181.0/255, green: 72.0/255, blue: 150.0/255))
                        .frame(width: 2, height: 60)
                        .cornerRadius(1)

                    VStack(alignment: .leading) {
                        Text("네트워크 개론")
                            .font(.custom("NotoSansKR-Bold", size: 16))
                        Text("E11 창의학습관 303호")
                            .font(.custom("NotoSansKR-Regular", size: 12))
                        Text("10:00-11:30")
                            .font(.custom("NotoSansKR-Medium", size: 12))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }.padding([.top, .leading, .bottom], 16)
        }
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
