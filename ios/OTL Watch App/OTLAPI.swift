//
//  OTLAPI.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 11/16/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import Foundation
import Alamofire
import SwiftUI

struct urls {
    static let BASE_URL = "https://otl.sparcs.org/"
    
    static let SESSION_URL = "session/"
    static let SESSION_INFO_URL = SESSION_URL + "info"

    static let API_URL = "api/"
    static let API_TIMETABLE_URL = API_URL + "users/{user_id}/timetables"
    static let API_SEMESTER_URL = API_URL + "semesters"


}

enum Days: Int {
    case mon = 0
    case tue = 1
    case wed = 2
    case thu = 3
    case fri = 4
    case sat = 5
    case sun = 6
}

struct LectureElement: Identifiable, Hashable {
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
    let classtime: Classtime
    let examtimes: [Examtime]
}

struct SemesterElement: Hashable, Codable {
    var year: Int
    var semester: Int
}

struct Timetable: Codable, Hashable {
    let id: Int
    var lectures: [Lecture]
}

struct Lecture: Codable, Hashable {
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

struct Professor: Codable, Hashable {
    let name: String
    let name_en: String
    let professor_id: Int
    let review_total_weight: Double
}

struct Classtime: Codable, Hashable {
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

struct Examtime: Codable, Hashable {
    let str: String
    let str_en: String
    let day: Int
    let begin: Int
    let end: Int
}

struct Semester: Codable, Hashable {
    let year: Int
    let semester: Int
    let beginning: Date?
    let end: Date?
    let courseDesciptionSubmission: Date?
    let courseRegistrationPeriodStart: Date?
    let courseRegistrationPeriodEnd: Date?
    let courseAddDropPeriodEnd: Date?
    let courseDropDeadline: Date?
    let courseEvaluationDeadline: Date?
    let gradePosting: Date?
}

struct UserInfo: Codable, Hashable {
    let id: Int
    let email: String
    let student_id: String
    let firstName: String
    let lastName: String
    let department: Department?
    let majors: [Department]
    let departments: [Department]
    let favorite_departments: [Department]
    let review_writable_lectures: [Lecture]
    let my_timetable_lectures: [Lecture]
}

struct Department: Codable, Hashable {
    let id: Int
    let name: String
    let name_en: String
    let code: String
}

@available(iOS 13.0, *)
func getColourForCourse(course: Int) -> Color {
    let colours = [
        [242.0, 206.0, 206.0],
        [244.0, 179.0, 174.0],
        [242.0, 188.0, 160.0],
        [240.0, 211.0, 171.0],
        [241.0, 225.0, 169.0],
        [244.0, 242.0, 179.0],
        [219.0, 244.0, 190.0],
        [190.0, 237.0, 215.0],
        [183.0, 226.0, 222.0],
        [201.0, 234.0, 244.0],
        [180.0, 211.0, 237.0],
        [185.0, 197.0, 237.0],
        [204.0, 198.0, 237.0],
        [216.0, 193.0, 240.0],
        [235.0, 202.0, 239.0],
        [244.0, 186.0, 219.0]
    ]
    
    return Color(red: Double(colours[course % 16][0]/255), green:Double(colours[course % 16][1]/255), blue:Double(colours[course % 16][2]/255))
}

class OTLAPI {
    func getTimetables(sessionID: String, userID: String, year: Int, semester: Int, completion: @escaping (Result<[Timetable], Error>) -> Void) {
        let cookieProperties = [
            HTTPCookiePropertyKey.domain: "otl.sparcs.org",
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "sessionid",
            HTTPCookiePropertyKey.value: sessionID
        ]

        if let cookie = HTTPCookie(properties: cookieProperties) {
            AF.session.configuration.httpCookieStorage?.setCookie(cookie)
        }
        
        AF.request(urls.BASE_URL + urls.API_TIMETABLE_URL.replacingOccurrences(of: "{user_id}", with: userID), method: .get, parameters: ["year": year, "semester": semester]).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode([Timetable].self, from: data)
                    completion(.success(json))
                } catch {
                    print("getTimetables Error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("getTimetables Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getSemesters(completion: @escaping (Result<[Semester], Error>) -> Void) {
        AF.request(urls.BASE_URL + urls.API_SEMESTER_URL, method: .get).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let json = try decoder.decode([Semester].self, from: data)
                    completion(.success(json))
                } catch {
                    print ("getSemesters Error \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("getSemesters Error: \(error)")
                completion(.failure(error))
            }
        }
    }

    func getActualTimetable(sessionID: String, userID: String, year: Int, semester: Int, completion: @escaping (Result<[Timetable], Error>) -> Void) {
        let cookieProperties = [
            HTTPCookiePropertyKey.domain: "otl.sparcs.org",
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "sessionid",
            HTTPCookiePropertyKey.value: sessionID
        ]

        if let cookie = HTTPCookie(properties: cookieProperties) {
            AF.session.configuration.httpCookieStorage?.setCookie(cookie)
        }

        AF.request(urls.BASE_URL + urls.SESSION_INFO_URL, method: .get).responseData { response in
            switch response.result {
            case .success(let data) :
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(UserInfo.self, from: data)
                    var timetable = Timetable(id: 0, lectures: [])
                    for lecture in json.my_timetable_lectures {
                        if lecture.year == year && lecture.semester == semester {
                            timetable.lectures.append(lecture)
                        }
                    }
                    completion(.success([timetable]))
                } catch {
                    print("getActualTimetable Error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("getActualTimetable Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getActualSemesters(sessionID: String, userID: String, completion: @escaping (Result<[SemesterElement], Error>) -> Void) {
        let cookieProperties = [
            HTTPCookiePropertyKey.domain: "otl.sparcs.org",
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "sessionid",
            HTTPCookiePropertyKey.value: sessionID
        ]

        if let cookie = HTTPCookie(properties: cookieProperties) {
            AF.session.configuration.httpCookieStorage?.setCookie(cookie)
        }

        AF.request(urls.BASE_URL + urls.SESSION_INFO_URL, method: .get).responseData { response in
            switch response.result {
            case .success(let data) :
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(UserInfo.self, from: data)
                    var semesters = [SemesterElement]()
                    for lecture in json.my_timetable_lectures {
                        semesters.append(SemesterElement(year: lecture.year, semester: lecture.semester))
                    }
                    semesters = Array(Set(semesters))
                    semesters = semesters.sorted(by: { this, next in
                        if this.year > next.year {
                            return true
                        } else if this.year == next.year {
                            return this.semester > next.semester
                        } else {
                            return false
                        }
                    })
                    completion(.success(semesters))
                } catch {
                    print("getActualSemesters Error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("getActualSemesters Error: \(error)")
                completion(.failure(error))
            }
        }
    }
}

