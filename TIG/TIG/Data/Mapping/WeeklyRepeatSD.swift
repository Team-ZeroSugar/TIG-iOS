//
//  WeeklyRepeatSD.swift
//  TIG
//
//  Created by 이정동 on 7/19/24.
//

import Foundation
import SwiftData

@Model
final class WeeklyRepeatSD {
    @Attribute(.unique) var day: Int
    @Relationship(deleteRule: .cascade) var timelines: [TimelineSD]
    
    init(day: Int, timelines: [TimelineSD]) {
        self.day = day
        self.timelines = timelines
    }
}

extension WeeklyRepeatSD {
    func toEntity() -> WeeklyRepeat {
        return WeeklyRepeat(
            day: self.day,
            timelines: self.timelines.map { $0.toEntity() }
        )
    }
}
