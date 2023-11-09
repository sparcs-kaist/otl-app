//
//  TimelineLabelView.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 11/9/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct TimelineLabelView: View {
    var body: some View {
        HStack {
            VStack(alignment: .trailing) {
                ForEach(4..<8) { number in
                    Spacer()
                    Text("\(number*3 > 12 ? number*3 - 12 : number*3)")
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .frame(height: 0)
                }
                Spacer()
            }.frame(width: 18)
            Spacer()
        }
    }
}

#Preview {
    TimelineLabelView()
}
