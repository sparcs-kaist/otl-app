//
//  DailyTableView.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 11/9/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct DailyTableView: View {
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
                }.frame(height: 801)
            }
            .navigationTitle("목")
        }
    }
}

#Preview {
    DailyTableView()
}
