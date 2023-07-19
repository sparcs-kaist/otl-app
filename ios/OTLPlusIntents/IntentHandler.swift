//
//  IntentHandler.swift
//  OTLPlusIntents
//
//  Created by Soongyu Kwon on 02/05/2023.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import Intents

class IntentHandler: INExtension, ConfigurationIntentHandling {
        
    
    struct Timetable: Decodable, Hashable {
        let id: Int
        let lectures: [Lecture]
    }

    struct Lecture: Decodable, Hashable {
        let id: Int
        let title: String
        let title_en: String
        let course: Int
        let old_code: String
        let class_no: String
        let year: Int
        let semester: Int
        let code: String
        let department: Int
        let department_code: String
        let department_name: String
        let department_name_en: String
        let type: String
        let type_en: String
        let limit: Int
        let num_people: Int
        let is_english: Bool
        let credit: Int
        let credit_au: Int
        let common_title: String
        let common_title_en: String
        let class_title: String
        let class_title_en: String
        let review_total_weight: Double
        let grade: Double
        let speech: Double
        let professors: [Professor]
        let classtimes: [Classtime]
        let examtimes: [Examtime]
    }

    struct Professor: Decodable, Hashable {
        let name: String
        let name_en: String
        let professor_id: Int
        let review_total_weight: Double
    }

    struct Classtime: Decodable, Hashable {
        let building_code: String
        let classroom: String
        let classroom_en: String
        let classroom_short: String
        let classroom_short_en: String
        let room_name: String
        let day: Int
        let begin: Int
        let end: Int
    }

    struct Examtime: Decodable, Hashable {
        let str: String
        let str_en: String
        let day: Int
        let begin: Int
        let end: Int
    }
    
    func provideNextClassTimetableOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<NextClassTimetable>?, Error?) -> Void) {
        let sharedDefaults = UserDefaults.init(suiteName: "group.org.sparcs.otl")
        var data: [Timetable]? = try? JSONDecoder().decode([Timetable].self, from: (sharedDefaults?.string(forKey: "widgetData")?.data(using: .utf8)) ?? Data())
        var tables: [NextClassTimetable] = []
        
        tables.append(NextClassTimetable(identifier: "0", display: "내 시간표"))
        for i in 1..<data!.count {
            tables.append(NextClassTimetable(identifier: "\(i)", display: "시간표 \(i)"))
        }
        
        let collection = INObjectCollection(items: tables)
        completion(collection, nil)
    }
    
}
