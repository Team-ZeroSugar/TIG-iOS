//
//  DateManager.swift
//  TIG
//
//  Created by 이정동 on 10/1/24.
//

import Foundation

final class DateManager {
  static let shared = DateManager()
  private init() {}
  
  func getCurrentDailyContentDate(from bedDate: Date) -> Date {
    let now = Date()
    
    if now >= bedDate {
      return now.addingTimeInterval(86400)
    } else {
      let newBed = bedDate.addingTimeInterval(-86400)
      
      if now >= newBed {
        return now
      } else {
        return now.addingTimeInterval(-86400)
      }
    }
  }
}
