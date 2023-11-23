//
//  DailyDayView.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 11/17/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct DailyDayView: View {
    @Binding var lecture: LectureElement
    @Binding var day: DayType
    
    @State private var showsDetailView = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 2)
                    .foregroundStyle(getColourForCourse(course: lecture.course))
                Text(lecture.title)
                    .foregroundStyle(.black)
                    .padding()
            }.onTapGesture {
                self.showsDetailView.toggle()
            }
            .navigationDestination(isPresented: self.$showsDetailView) {
                LectureDetailView(lecture: self.$lecture, day: self.$day)
            }
        }
    }
}
