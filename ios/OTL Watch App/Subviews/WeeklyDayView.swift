//
//  WeeklyDayView.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 11/16/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct WeeklyDayView: View {
    @Binding var lectures: [LectureElement]
    @Binding var day: DayType
    
    @State private var showsDailyTableView = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color(red: 51/256, green: 51/256, blue: 51/256))
                ForEach(self.lectures) { lecture in
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundStyle(getColourForCourse(course: lecture.course))
                        .frame(height: Double(lecture.classtime.end - lecture.classtime.begin)/60*14-1)
                        .offset(y: CGFloat(Double(lecture.classtime.begin - 540)/60*14))
                }
            }
            .onTapGesture {
                self.showsDailyTableView.toggle()
            }
            .navigationDestination(isPresented: self.$showsDailyTableView) {
                DailyTableView(lectures: self.$lectures, day: self.$day)
            }
        }
    }
}
