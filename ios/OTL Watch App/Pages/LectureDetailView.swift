//
//  LectureDetailView.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 11/21/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import SwiftUI

extension Color {
    func adjust(hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, opacity: CGFloat = 1) -> Color {
        let color = UIColor(self)
        var currentHue: CGFloat = 0
        var currentSaturation: CGFloat = 0
        var currentBrigthness: CGFloat = 0
        var currentOpacity: CGFloat = 0

        if color.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentOpacity) {
            return Color(hue: currentHue + hue, saturation: currentSaturation + saturation, brightness: currentBrigthness + brightness, opacity: currentOpacity + opacity)
        }
        return self
    }
}

struct LectureDetailView: View {
    @Binding var lecture: LectureElement
    @Binding var day: DayType
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundStyle(LinearGradient(colors: [getColourForCourse(course: lecture.course).adjust(brightness: -0.15), getColourForCourse(course: lecture.course).adjust(brightness: -0.75)], startPoint: .top, endPoint: .bottom))
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("\(self.day.rawValue)요일 \(lecture.classtime.begin/60):\(lecture.classtime.begin%60)-\(lecture.classtime.end/60):\(lecture.classtime.end%60)")
                            .font(.system(size: 15))
                            .foregroundStyle(getColourForCourse(course: lecture.course).adjust(brightness: 0.5))
                        HStack(alignment: .top) {
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(Color.accentColor)
                                .offset(y: 7)
                            Text(lecture.title)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(lecture.classtime.classroom)
                            .font(.system(size: 13))
                        Text("\(lecture.professors[0].name) 교수님")
                            .font(.system(size: 13))
                    }
                }.padding()
            }
        }
    }
}
