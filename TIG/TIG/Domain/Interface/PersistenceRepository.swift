//
//  PersistenceRepository.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import Foundation

protocol PersistenceRepository {
    // DailyContent 관련
    func createDailyContent()
    func fetchDailyContents() -> [DailyContent]
    func updateDailyContent()
    func deleteDailyContent()
    
    // WeeklyRepeat 관련
    func createWeeklyRepeat()
    func fetchWeeklyRepeats() -> [WeeklyRepeat]
    func updateWeeklyRepeat()
}
