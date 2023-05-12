//
//  TodayClassesWidget.swift
//  next class widgetExtension
//
//  Created by Soongyu Kwon on 12/05/2023.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct TodayClassesWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color(red: 249.0/255, green: 240.0/255, blue: 240.0/255)
            Group {
                ZStack {
                    HStack {
                        ForEach(9..<25) { number in
                            if number%6 == 0 {
                                VStack {
                                    Text("\(number%12 == 0 ? 12 : number%12)")
                                        .fontWeight(.bold)
                                    Line()
                                        .stroke(style: StrokeStyle(lineWidth: 1))
                                        .frame(width: 1)
                                        .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.25))
                                }
                            } else {
                                VStack {
                                    Text("\(number%12 == 0 ? 12 : number%12)")
                                    Line()
                                        .stroke(style: StrokeStyle(lineWidth: 1))
                                        .frame(width: 1)
                                        .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.25))
                                }
                            }
                            if number != 24 {
                                Spacer()
                                VStack {
                                    Spacer()
                                        .frame(height: 24)
                                    Line()
                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                                        .frame(width: 1)
                                        .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.25))
                                }
                                Spacer()
                            }
                        }
                    }.font(.system(size: 12))
                    TodayClassesLectureView(lectureName: "인터랙션 프로토타이핑", lecturePlace: "(N15) 414")
                        .frame(width: 85, height: 100)
                        .position(x: 109.3, y: 74) // 109.3
                        .offset(x: -7.5)
                }.frame(width: 830)
                    .offset(x: 260)
                    
            }.padding(16)
        }
    }
}

struct TodayClassesLectureView: View {
    let lectureName: String
    let lecturePlace: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .padding(.horizontal, 1)
                .foregroundColor(Color(red: 212.0/255, green: 194.0/255, blue: 237.0/255))
            VStack(alignment: .leading) {
                Text(lectureName)
                    .font(.custom("NotoSansKR-Regular", size: 12))
                Text(lecturePlace)
                    .font(.custom("NotoSansKR-Regular", size: 12))
                    .foregroundColor(Color(red: 102.0/255, green: 102.0/255, blue: 102.0/255))
                Spacer()
            }.padding(.vertical, 10)
        }
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
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
        TodayClassesWidgetEntryView(entry: WidgetEntry(date: Date(), timetableData: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
