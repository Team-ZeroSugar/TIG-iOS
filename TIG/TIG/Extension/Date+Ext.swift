//
//  Date+Edt.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import Foundation

extension Date {
  
  /// M월 d일 EEE
  var pickerFormat: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "M월 d일 EEE"
    return formatter.string(from: self)
  }
  
  /// Date 값이 어떤 날짜인지를 표현
  var formattedDate: Self {
    var calendar = Calendar.current
    
    // 달력 표기 방법 설정
    calendar.locale = .current
    // 타임존(UTC 시간관련된 개념) 설정
    calendar.timeZone = .current
    
    let dateComponent = calendar.dateComponents([.year, .month, .day, .weekday], from: self)
    
    return calendar.date(from: dateComponent)!
  }
  
  /// 요일을 반환 (일: 1 ~ 토: 7)
  var weekday: Int {
    let dateComponent = Calendar.current.dateComponents([.weekday], from: self)
    return dateComponent.weekday!
  }
  
  func formattedTimelineTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "a h시"
    formatter.amSymbol = "오전"
    formatter.pmSymbol = "오후"
    
    let minuteFormatter = DateFormatter()
    minuteFormatter.dateFormat = "mm"
    
    let formattedTime = formatter.string(from: self)
    let minutes = minuteFormatter.string(from: self)
    
    if minutes == "00" {
      return formattedTime
    } else {
      return formattedTime + " " + minutes + "분"
    }
    
  }
  
  func convertToDateCompontents() -> DateComponents {
    let calendar = Calendar.current
    return calendar.dateComponents([.hour, .minute], from: self)
  }
}
