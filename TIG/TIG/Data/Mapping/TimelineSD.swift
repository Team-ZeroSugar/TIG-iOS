//
//  TimelineSD.swift
//  TIG
//
//  Created by 이정동 on 7/19/24.
//

import Foundation
import SwiftData

@Model
final class TimelineSD {
    var start: Date
    var end: Date
    var isAvailable: Bool
    
    init(start: Date, end: Date, isAvailable: Bool) {
        self.start = start
        self.end = end
        self.isAvailable = isAvailable
    }
}

extension TimelineSD {
    func toEntity() -> Timeline {
        return Timeline(
            start: self.start,
            end: self.end,
            isAvailable: self.isAvailable
        )
    }
}
