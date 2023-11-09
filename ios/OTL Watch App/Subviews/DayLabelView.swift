//
//  DayLabelView.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 11/9/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import SwiftUI

enum DayType: String {
    case sun = "일"
    case mon = "월"
    case tue = "화"
    case wed = "수"
    case thu = "목"
    case fri = "금"
    case sat = "토"
}

struct DayLabelView: View {
    @Binding var day: DayType
    @Binding var isHighlighted: Bool
    
    var body: some View {
        ZStack {
            if isHighlighted {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(.accent)
            }
            Text(day.rawValue)
                .fontWeight(.medium)
        }.frame(width: 22, height: 20)
    }
}

#Preview("DayLabelView", traits: .sizeThatFitsLayout) {
    VStack {
        DayLabelView(day: .constant(.mon), isHighlighted: .constant(false))
        DayLabelView(day: .constant(.fri), isHighlighted: .constant(true))
    }
}
