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
        // Non-interactive widgets for iOS 15+
        NextClassWidget()
        TodayClassesWidget()
        WeekClassesWidget()
        
        // Lock Complications accessories for iOS 16+
        if #available(iOSApplicationExtension 16.0, *) {
            NextClassAccessory()
            TimeInlineAccessory()
            LocationInlineAccessory()
        }
    }
}
