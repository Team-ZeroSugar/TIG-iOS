//
//  SwiftDataService.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import Foundation
import SwiftData

final class DefaultDailyContentRepository: SwiftDataStorage {
    
}

extension DefaultDailyContentRepository: DailyContentRepository {
    
    func createDailyContent() {
        
    }
    
    func fetchDailyContents() -> [DailyContent] {
        return []
    }
    
    func updateDailyContent() {
        
    }
    
    func deleteDailyContent() {
        
    }
}
