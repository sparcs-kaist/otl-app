//
//  HorizontalLine.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 11/9/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct HorizontalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

#Preview {
    HorizontalLine()
}
