//
//  TimeLine.swift
//  TIG
//
//  Created by 이정동 on 7/19/24.
//

import Foundation

struct Timeline: Equatable {
    var start: DateComponents
    var end: DateComponents
    var isAvailable: Bool
}

struct TimelineGroup {
  var start: DateComponents
  var end: DateComponents
  var isAvailable: Bool
  var count: Int
}
