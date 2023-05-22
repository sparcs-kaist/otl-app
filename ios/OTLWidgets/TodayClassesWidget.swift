//
//  TodayClassesWidget.swift
//  OTLWidgetsExtension
//
//  Created by Soongyu Kwon on 12/05/2023.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct TodayClassesWidgetData: Hashable {
    let title: String
    let place: String
    let width: Double
    let x: Double
    let colour: Color
}



struct TodayClassesWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color(red: 249.0/255, green: 240.0/255, blue: 240.0/255)
            Color.clear
                .overlay(
                    Group {
                        ZStack(alignment: .leading) {
                            HStack {
                                ForEach(9..<25) { number in
                                    VStack {
                                        Text("\(number%12 == 0 ? 12 : number%12)")
                                            .frame(width: 40)
                                            .multilineTextAlignment(.center)
                                            .font(.system(size: 12, weight: number%6==0 ? .bold : .regular))
                                        VerticalLine()
                                            .stroke(style: StrokeStyle(lineWidth: 1))
                                            .frame(width: 1)
                                            .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.25))
                                    }
                                    if number != 24 {
                                        Spacer()
                                        VStack {
                                            Spacer()
                                                .frame(height: 24)
                                            VerticalLine()
                                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                                                .frame(width: 1)
                                                .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.25))
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            if (entry.timetableData != nil) {
                                ForEach(getLecturesDataForToayClassesWidget(data: entry.todayLectures!), id: \.self) { data in
                                    VStack {
                                        Spacer()
                                            .frame(height: 24)
                                        TodayClassesLectureView(lectureName: data.title, lecturePlace: data.place, colour: data.colour)
                                            .frame(width: data.width)
                                            .offset(x: data.x)
                                        Spacer()
                                            .frame(height: 2)
                                    }
                                }
                            }
                        }
                    }.padding(.vertical, 16)
                        .offset(x: getOffsetByDate(date: entry.date))
                    , alignment: .leading
                )
        }
    }
    
    func getOffsetByDate(date: Date) -> CGFloat {
        var tmp = 0
        let hour = Calendar.current.component(.hour, from: date)
        
        if hour > 9 {
            tmp = hour >= 19 ? -570 : -57*(hour-9)
        }
        
        
        return CGFloat(tmp)
    }
}



func getLecturesDataForToayClassesWidget(data: [(Int, Lecture)]) -> [TodayClassesWidgetData] {
    var tmp = [TodayClassesWidgetData]()
    
    for (i, l) in data {
        let c = l.classtimes[i]
        
        let title = l.title
        let place = c.classroom_short
        let width = (0.9388*Double(c.end-c.begin)*10).rounded()/10
        let x = 20 + (Double(c.begin-540)*0.95*10).rounded()/10
        let colour = getColourForCourse(course: l.course)
        
        tmp.append(TodayClassesWidgetData(title: title, place: place, width: width, x: x, colour: colour))
    }
    
    return tmp
}

func getTodayLectures(timetable: Timetable?, date: Date) -> [(Int, Lecture)] {
    var tmp: [(Int, Lecture)] = [(Int, Lecture)]()
    if (timetable == nil) {
        return tmp
    }
    
    let calendar = Calendar.current
    var day = getDayWithWeekDay(weekday: calendar.component(.weekday, from: date))
    
    while tmp.count == 0 {
        for l in timetable!.lectures {
            for i in 0..<l.classtimes.count {
                let c = l.classtimes[i]
                if c.day == day {
                    tmp.append((i, l))
                }
            }
        }
        day = (day >= 7) ? 0 : day + 1
    }
    
    return tmp
}

struct TodayClassesLectureView: View {
    let lectureName: String
    let lecturePlace: String
    let colour: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .foregroundColor(colour)
            HStack {
                VStack(alignment: .leading) {
                    Text(lectureName)
                        .font(.custom("NotoSansKR-Regular", size: 12))
                    Text(lecturePlace)
                        .font(.custom("NotoSansKR-Regular", size: 12))
                        .foregroundColor(Color(red: 102.0/255, green: 102.0/255, blue: 102.0/255))
                    Spacer()
                }.padding(.vertical, 8)
                Spacer()
            }.padding(.horizontal, 8)
        }
        .padding(.horizontal, 2)
    }
}

struct TodayClassesWidget: Widget {
    let kind: String = "TodayClassesWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TodayClassesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("오늘 수업")
        .description("오늘 수업을 확인합니다.")
        .supportedFamilies([.systemMedium])
    }
}

struct TodayClassesWidgetPreviews: PreviewProvider {
    static var previews: some View {
        TodayClassesWidgetEntryView(entry: WidgetEntry(date: Date(), timetableData: nil, todayLectures: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
