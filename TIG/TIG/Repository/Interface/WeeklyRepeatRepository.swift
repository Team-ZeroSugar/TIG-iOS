//
//  WeeklyRepeatRepository.swift
//  TIG
//
//  Created by 이정동 on 7/20/24.
//

import Foundation

protocol WeeklyRepeatRepository {
  func initialWeeklyRepeats()
  func fetchWeeklyRepeats() -> Result<[WeeklyRepeat], SwiftDataError>
  func readWeelkyRepeat(weekday: Int) -> Result<WeeklyRepeat, SwiftDataError>
  func updateWeeklyRepeat(weeklyRepeat: WeeklyRepeat, timelines: [Timeline])
}
