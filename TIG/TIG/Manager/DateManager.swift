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
  
  private let oneDay: TimeInterval = 86400
  
  func getCurrentDailyContentDate() -> Date {
    let sleepTime = getSleepTimeMinutes()
    let bedDate = sleepTime.bed.convertToDateFormatFromMinutes()
    let now = Date()
    
    if now >= bedDate {
      return now.addingTimeInterval(oneDay)
    } else {
      let newBed = bedDate.addingTimeInterval(-oneDay)
      
      if now >= newBed {
        return now
      } else {
        return now.addingTimeInterval(-oneDay)
      }
    }
  }
  
  func getSleepTimeMinutes() -> (wakeup: Int, bed: Int) {
    let wakeupTime = UserDefaults.standard.integer(forKey: UserDefaultsKey.wakeupTimeIndex) * 30
    var bedTime = UserDefaults.standard.integer(forKey: UserDefaultsKey.bedTimeIndex) * 30
    
    if wakeupTime > bedTime {
        bedTime += 60 * 24
    }
    
    return (wakeupTime, bedTime)
  }
}
