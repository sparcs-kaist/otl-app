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
                    Text(LocalizedStringKey("nextclasswidget.nextlecture"))
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
                    Text(getPlace(timetable: entry.timetableData![Int(entry.configuration.nextClassTimetable?.identifier ?? "0") ?? 0], date: entry.date))
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
                    Text(LocalizedStringKey("nextclasswidget.nextlecture"))
                        .font(.custom("NotoSansKR-Bold", size: 12))
                        .foregroundColor(Color(red: 229.0/255, green: 76.0/255, blue: 100.0/255))
                    Text(LocalizedStringKey("nextclasswidget.nodata"))
                        .font(.custom("NotoSansKR-Bold", size: 20))
                        .offset(y: -2)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack {
                        Circle()
                            .fill(getColourForCourse(course: 1))
                            .frame(width: 12, height: 12)
                        Text(LocalizedStringKey("nextclasswidget.nodata"))
                            .font(.custom("NotoSansKR-Bold", size: 16))
                            .minimumScaleFactor(0.5)
                            .lineLimit(2)
                    }.offset(y: 8)
                    Text(LocalizedStringKey("nextclasswidget.nodata"))
                        .font(.custom("NotoSansKR-Regular", size: 12))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    Text(LocalizedStringKey("nextclasswidget.nodata"))
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
                            Text(LocalizedStringKey("widget.login"))
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
        
        return NSLocale.current.language.languageCode?.identifier == "en" ? lecture.common_title_en : lecture.common_title
    }
    
    func getProfessor(timetable: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetable, date: date)
        let lecture: Lecture = c.1
        
        return NSLocale.current.language.languageCode?.identifier == "en" ? String(format: String(localized: "nextclasswidget.professor"), lecture.professors[0].name_en) : String(format: String(localized: "nextclasswidget.professor"), lecture.professors[0].name)
    }
    
    func getPlace(timetable: Timetable, date: Date) -> String {
        let c = getNextClass(timetable: timetable, date: date)
        let index = c.0
        let lecture: Lecture = c.1
        
        return NSLocale.current.language.languageCode?.identifier == "en" ? lecture.classtimes[index].classroom_short_en : lecture.classtimes[index].classroom
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
            return String(format: String(localized: "nextclasswidget.today.timeformat"), begin/60, begin%60)
        } else if lday == day+1 {
            return String(format: String(localized: "nextclasswidget.tomorrow.timeformat"), begin/60, begin%60)
        } else if lday > day+1 {
            return String(format: String(localized: "nextclasswidget.day.timeformat"), getDayInString(day: lday), begin/60, begin%60)
        } else {
            return String(format: String(localized: "nextclasswidget.nextweek.timeformat"), getDayInString(day: lday))
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
    private let title: LocalizedStringKey = "nextclasswidget.title"
    private let description: LocalizedStringKey = "nextclasswidget.description"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NextClassWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(title)
        .description(description)
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabledIfAvailable()
    }
}

struct NextClassWidgetPreviews: PreviewProvider {
    static var previews: some View {
        NextClassWidgetEntryView(entry: WidgetEntry(date: Date(), timetableData: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
