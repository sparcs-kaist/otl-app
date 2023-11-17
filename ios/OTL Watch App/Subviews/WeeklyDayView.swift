//
//  WeeklyDayView.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 11/16/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct WeeklyDayView: View {
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(Color(red: 51/256, green: 51/256, blue: 51/256))
        }
    }
}

#Preview {
    WeeklyDayView()
}
