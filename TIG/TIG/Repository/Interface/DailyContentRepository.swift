//
//  PersistenceRepository.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import Foundation

protocol DailyContentRepository {
  func createDailyContent(_ dailyContent: DailyContent)
  func fetchDailyContents() -> Result<[DailyContent], SwiftDataError>
  func readDailyContent(date: Date) -> Result<DailyContent, SwiftDataError>
  func updateDailyContent(dailyContent: DailyContent, timelines: [Timeline])
  func deleteDailyContent(_ dailyContent: DailyContent)
}
