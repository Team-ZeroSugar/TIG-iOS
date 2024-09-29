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
    let minutes = (self % 60)/* / 60*/
    return String(format: "%01d시간 %01d분", hours, minutes)
  }
  
  /// 0..<48 범위에 존재하는 값을 시간으로 변환
  /// 0 : 오전 12:00 / 1 : 오전 12:30 / ... / 47 : 오후 11:30
  /// - Returns: ex) 오전 12:00
  func convertToKoreanTimeFormat() -> String {
    let ampm = self / 24 == 1 ? "오후" : "오전"
    var hour = self < 26 ? self / 2 : self / 2 - 12
    if hour == 0 { hour = 12 }
    
    let minute = self % 2 == 0 ? "00" : "30"
    
    return String(format: "%@ %2d:%@", ampm, hour, minute)
  }
  
  /// 0..<48 범위에 존재하는 값을 Date로 변환
  /// 0 : 00:00 / 1 : 00:30 / ... / 47 : 23:30
  /// - Returns: ex) 00:00
  func convertToDateFormat() -> Date {
    let calendar = Calendar.current
    let now = Date()
    let ymd = calendar.dateComponents([.year, .month, .day], from: now)
    let hour = self / 2
    let minute = self % 2 == 0 ? 0 : 30
    
    var components = DateComponents()
    components.year = ymd.year
    components.month = ymd.month
    components.day = ymd.day
    components.hour = hour
    components.minute = minute
    
    return calendar.date(from: components)!
  }
  
  /// 0..<48 범위에 존재하는 값을 DateComponents로 변환
  /// 0 : 00:00 / 1 : 00:30 / ... / 47 : 23:30
  /// - Returns: ex) 00:00
  func convertToDateComponents() -> DateComponents {
    return DateComponents(
      hour: self / 2,
      minute: self % 2 == 0 ? 0 : 30
    )
  }
}
