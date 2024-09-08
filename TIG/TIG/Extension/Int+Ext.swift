//
//  Int+Ext.swift
//  TIG
//
//  Created by 신승재 on 8/6/24.
//

import Foundation

extension Int {
  var minutesFormat: String {
    self / 10 == 0 ? "0\(self)" : "\(self)"
  }
  
  func formattedDuration() -> String {
    let totalMinutes = self * 30
    let hours = totalMinutes / 60
    let minutes = totalMinutes % 60
    
    var result = ""
    if hours > 0 {
      result += "\(hours)시간"
    }
    if minutes > 0 {
      if !result.isEmpty {
        result += " "
      }
      result += "\(minutes)분"
    }
    return result
  }
  
  func formattedTime() -> String {
    let hours = self / 60
    let minutes = (self % 60) / 60
    return String(format: "%01d시간 %01d분", hours, minutes)
  }
  
  func convertKoreanTimeFormat() -> String {
    let ampm = self / 24 == 1 ? "오후" : "오전"
    var hour = "\(self / 2)"
    let minute = self % 2 == 0 ? "00" : "30"
    
    return "\(ampm) \(hour):\(minute)"
  }
}
