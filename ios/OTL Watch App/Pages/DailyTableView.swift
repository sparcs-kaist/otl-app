//
//  DailyTableView.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 11/9/23.
//

import SwiftUI

@available(iOS 17.0, *)
struct DailyTableView: View {
    @Binding var lectures: [LectureElement]
    @Binding var day: DayType
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    VStack(alignment: .trailing) {
                        ForEach(3..<9) { number in
                            if number == 3 {
                                Spacer()
                                    .frame(height: 50)
                            }
                            Text("\(number*3 > 12 ? number*3 - 12 : number*3)")
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                                .frame(height: 0)
                            if number != 8 {
                                Spacer()
                            }
                        }
                    }.frame(width: 18)
                    ZStack(alignment: .top) {
                        VStack {
                            ForEach(0..<33) { number in
                                if number % 2 == 0 {
                                    HorizontalLine()
                                        .stroke(style: StrokeStyle(lineWidth: 1))
                                        .frame(height: 1)
                                        .foregroundStyle(Color.white.opacity(0.25))
                                } else {
                                    HorizontalLine()
                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                                        .frame(height: 1)
                                        .foregroundStyle(Color.white.opacity(0.25))
                                }
                                if number != 32 {
                                    Spacer()
                                }
                            }
                        }
                        ForEach(self.lectures) { lecture in
                            NavigationLink(destination: LectureDetailView(lecture: .constant(lecture), day: self.$day)) {
                                DailyDayView(lecture: .constant(lecture))
                            }.buttonStyle(.plain)
                            .frame(height: Double(Double(lecture.classtime.end - lecture.classtime.begin)/720+(Double(lecture.classtime.end - lecture.classtime.begin)/27)-1))
                            .offset(y: Double(51 + Double(lecture.classtime.begin-540)/3001))
                        }
                    }
                }.frame(height: 801)
            }
            .navigationTitle("\(self.day.rawValue)요일")
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    DailyTableView(lectures: .constant([LectureElement]()), day: .constant(.mon))
}
