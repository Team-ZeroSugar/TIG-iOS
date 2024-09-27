//
//  DailyContentSD.swift
//  TIG
//
//  Created by 이정동 on 7/19/24.
//

import Foundation
import SwiftData

@Model
final class DailyContentSD {
    @Attribute(.unique) var date: Date
    @Relationship(deleteRule: .cascade) var timelines: [TimelineSD]
    var totalAvailabilityTime: Int
    
    init(date: Date, timelines: [TimelineSD], totalAvailabilityTime: Int) {
        self.date = date
        self.timelines = timelines
        self.totalAvailabilityTime = totalAvailabilityTime
    }
}

extension DailyContentSD {
    func toEntity() -> DailyContent {
        return DailyContent(
            date: self.date,
            timelines: formatDateComponents(self.timelines),
            totalAvailabilityTime: self.totalAvailabilityTime
        )
    }
  
    private func formatDateComponents(_ timelines: [TimelineSD]) -> [Timeline] {
      var timelineEntities = self.timelines.map { $0.toEntity() }
      if timelineEntities.isEmpty { return [] }
      
      let curDay = timelineEntities[0].start.day!
    
      for (idx, entity) in timelineEntities.enumerated() {
          if entity.start.day! != curDay {
            timelineEntities[idx].start.hour! += 24
          }
      }
      
      return timelineEntities
    }
}
