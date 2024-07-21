//
//  WeeklyRepeat.swift
//  TIG
//
//  Created by 이정동 on 7/19/24.
//

import Foundation

struct WeeklyRepeat {
    var day: Weekly
    var timelines: [Timeline]
}

enum Weekly: Int, Codable {
    case sun
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
}
