//
//  PersistenceRepository.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import Foundation

protocol DailyContentRepository {
    func createDailyContent()
    func fetchDailyContents() -> [DailyContent]
    func updateDailyContent()
    func deleteDailyContent()
}
