//
//  WeeklyTableView.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 11/9/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct WeeklyTableView: View {
    @State private var scrollOffset: CGFloat = CGFloat.zero
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Contents
                VStack {
                    Spacer()
                        .frame(height: 25)
                    ObservableScrollView(scrollOffset: self.$scrollOffset) {
                        ZStack {
                            TimelineLabelView()
                            HStack {
                                Spacer()
                                    .frame(width: 20)
                                WeeklyDayView()
                                Spacer()
                                WeeklyDayView()
                                Spacer()
                                WeeklyDayView()
                                Spacer()
                                WeeklyDayView()
                                Spacer()
                                WeeklyDayView()
                            }
                        }.frame(height: 210)
                        
                        Button(action: {}, label: {
                            HStack {
                                Image(systemName: "gearshape.fill")
                                Text("시간표 설정")
                                    .fontWeight(.medium)
                            }
                        })
                        .padding(.top, 18)
                        .padding(.horizontal, 25)
                    }
                }
                
                
                // MARK: - Header
                VStack {
                    ZStack(alignment: .bottom) {
                        Color.black
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            Spacer()
                            DayLabelView(day: .constant(.mon), isHighlighted: .constant(false))
                            Spacer()
                            Spacer()
                            DayLabelView(day: .constant(.tue), isHighlighted: .constant(false))
                            Spacer()
                            Spacer()
                            DayLabelView(day: .constant(.wed), isHighlighted: .constant(false))
                            Spacer()
                            Spacer()
                            DayLabelView(day: .constant(.thu), isHighlighted: .constant(true))
                            Spacer()
                            Spacer()
                            DayLabelView(day: .constant(.fri), isHighlighted: .constant(false))
                            Spacer()
                        }.offset(y: -2)
                    }
                    .frame(height: 25)
                    .offset(y: self.scrollOffset < 0 ? -self.scrollOffset : 0)
                    Spacer()
                }
                
                
            }
            .navigationTitle("23 가을")
        }
    }
}

#Preview {
    WeeklyTableView()
}
