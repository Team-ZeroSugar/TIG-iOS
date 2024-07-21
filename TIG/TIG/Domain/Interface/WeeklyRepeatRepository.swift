//
//  WeeklyRepeatRepository.swift
//  TIG
//
//  Created by 이정동 on 7/20/24.
//

import Foundation

protocol WeeklyRepeatRepository {
    func createWeeklyRepeat()
    func fetchWeeklyRepeats() -> [WeeklyRepeat]
    func updateWeeklyRepeat()
}
