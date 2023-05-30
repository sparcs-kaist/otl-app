//
//  OTLWidgetBundle.swift
//  OTLWidgetsExtension
//
//  Created by Soongyu Kwon on 28/03/2023.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct OTLWidgetBundle : WidgetBundle {
    var body: some Widget {
        NextClassWidget()
        TodayClassesWidget()
        WeekClassesWidget()
    }
}
