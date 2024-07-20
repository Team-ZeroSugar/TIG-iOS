//
//  SwiftDataService.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import Foundation
import SwiftData

final class DefaultPersistenceRepository {
    var context: ModelContext = {
        let schema = Schema([DailyContentSD.self, WeeklyRepeatSD.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            return ModelContext(container)
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
}

extension DefaultPersistenceRepository: PersistenceRepository {
    // DailyContent 관련
    
    func createDailyContent() {
        
    }
    
    func fetchDailyContents() -> [DailyContent] {
        return []
    }
    
    func updateDailyContent() {
        
    }
    
    func deleteDailyContent() {
        
    }
    
    // WeeklyRepeat 관련
    
    func createWeeklyRepeat() {
        
    }
    
    func fetchWeeklyRepeats() -> [WeeklyRepeat] {
        return []
    }
    
    func updateWeeklyRepeat() {
        
    }
}
