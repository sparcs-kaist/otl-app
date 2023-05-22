//
//  WeekClassesWidget.swift
//  OTLWidgetsExtension
//
//  Created by Soongyu Kwon on 14/05/2023.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct WeekClassesWidgetData: Hashable {
    let title: String
    let height: Double
    let y: Double
    let colour: Color
}

struct WeekClassesWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 249.0/255, green: 240.0/255, blue: 240.0/255)
            Group {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 17)
                    Color.clear
                        .overlay(
                            HStack(spacing: 2) {
                                TimeLabelView()
                                ForEach(0..<5) { number in
                                    ZStack(alignment: .topLeading) {
                                        TableLineView()
                                        ForEach(getLecturesDataForWeekClassesWidget(data: getLecturesForDay(timetable: entry.timetableData?[Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], day: number)), id: \.self) { data in
                                            WeekClassesLectureView(lectureName: data.title, colour: data.colour)
                                                .frame(height: data.height)
                                                .offset(y: data.y)
                                        }
                                    }
                                }
                            }
                            , alignment: .top
                        )
                        .offset(y: getOffsetByDate(date: entry.date))
                }
            }.padding(16)
            GeometryReader { proxy in
                ZStack {
                    Color(red: 249.0/255, green: 240.0/255, blue: 240.0/255)
                        .frame(height: 33)
                        .offset(y: -5)
                    Color(red: 249.0/255, green: 240.0/255, blue: 240.0/255)
                        .frame(width: proxy.size.width-45, height: 37)
                        .offset(x: 10)
                    HStack {
                        Spacer()
                            .frame(width: 18)
                        ForEach(["월", "화", "수", "목", "금"], id: \.self) { text in
                            Spacer()
                            Text(text)
                                .offset(y: -2)
                            Spacer()
                        }
                    }.font(.custom("NotoSansKR-Regular", size: 12))
                        .offset(y: 10)
                }.padding(.horizontal, 16)
            }
        }
    }

    func getOffsetByDate(date: Date) -> CGFloat {
        var tmp = 0
        let hour = Calendar.current.component(.hour, from: date)
        
        if hour > 9 {
            tmp = hour >= 18 ? -387 : -43*(hour-9)
        }
        
        return CGFloat(tmp)
    }
}

func getLecturesDataForWeekClassesWidget(data: [(Int, Lecture)]) -> [WeekClassesWidgetData] {
    var tmp = [WeekClassesWidgetData]()
    
    for (i, l) in data {
        let c = l.classtimes[i]
        
        let title = l.title
        let minute = c.end - c.begin
        var height = 0.6833 * Double(minute)
        if minute/30 != 0 {
            height = height + Double(minute/30 - 1)
        }
        let y = 0.7166 * Double(c.begin - 540) + 5
        let colour = getColourForCourse(course: l.course)
        
        tmp.append(WeekClassesWidgetData(title: title, height: height, y: y, colour: colour))
    }
    
    return tmp
}

func getLecturesForDay(timetable: Timetable?, day: Int) -> [(Int, Lecture)] {
    var tmp: [(Int, Lecture)] = [(Int, Lecture)]()
    if (timetable == nil) {
        return tmp
    }
    
    for l in timetable!.lectures {
        for i in 0..<l.classtimes.count {
            let c = l.classtimes[i]
            if c.day == day {
                tmp.append((i, l))
            }
        }
    }
    
    return tmp
}


struct TimeLabelView: View {
    var body: some View {
        VStack(spacing: 12) {
            ForEach(9..<25) { number in
                HStack(spacing: 2) {
                    Text("\(number%12 == 0 ? 12 : number%12)")
                        .frame(width: 14, height: 18, alignment: .trailing)
                        .font(.custom("NotoSansKR-Regular", size: 12))
                    HorizontalLine()
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .frame(width: 0, height: 1)
                        .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.25))
                }
                if number != 24 {
                    HStack(spacing: 2) {
                        HorizontalLine()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                            .frame(width: 0, height: 1)
                            .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.25))
                    }
                }
            }
        }.offset(y: -4)
    }
}

struct TableLineView: View {
    var body: some View {
        VStack(spacing: 12) {
            ForEach(9..<25) { number in
                HStack(spacing: 0) {
                    Text("\(number%12 == 0 ? 12 : number%12)")
                        .frame(width: 0, height: 18, alignment: .trailing)
                        .font(.custom("NotoSansKR-Regular", size: 12))
                    HorizontalLine()
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .frame(height: 1)
                        .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.25))
                }
                if number != 24 {
                    HStack(spacing: 0) {
                        HorizontalLine()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                            .frame(height: 1)
                            .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.25))
                    }
                }
            }
        }.offset(y: -4)
    }
}


struct WeekClassesLectureView: View {
    let lectureName: String
    let colour: Color
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 2)
                .foregroundColor(colour)
                .padding(.vertical, 2)
            Text(lectureName)
                .font(.custom("NotoSansKR-Regular", size: 10))
                .padding([.leading, .top], 4)
        }
    }
}


struct WeekClassesWidget: Widget {
    let kind: String = "WeekClassesWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WeekClassesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("주간 시간표")
        .description("일주일의 모든 수업을 확인합니다.")
        .supportedFamilies([.systemLarge])
    }
}

struct WeekClassesWidgetPreviews: PreviewProvider {
    static var previews: some View {
        WeekClassesWidgetEntryView(entry: WidgetEntry(date: Date(), timetableData: nil, todayLectures: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
