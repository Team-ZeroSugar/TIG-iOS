//
//  TimelineUseCase.swift
//  TIG
//
//  Created by 신승재 on 7/21/24.
//

import SwiftUI

@Observable
class TimelineUseCase {
    
    // MARK: - State
    struct State {
        // View State
        var editTimeline: Bool = false
        
        // Data State
        // 구현을 위한 임시 Data
        //var timelines: [Timeline] = []
        let timelines: [Timeline] = [
            Timeline(start: Date(timeIntervalSince1970: 1721452800), end: Date(timeIntervalSince1970: 1721454600), isAvailable: true),  // 2024/07/21 09:00 - 09:30
            Timeline(start: Date(timeIntervalSince1970: 1721454600), end: Date(timeIntervalSince1970: 1721456400), isAvailable: false), // 2024/07/21 09:30 - 10:00
            Timeline(start: Date(timeIntervalSince1970: 1721456400), end: Date(timeIntervalSince1970: 1721458200), isAvailable: true),  // 2024/07/21 10:00 - 10:30
            Timeline(start: Date(timeIntervalSince1970: 1721458200), end: Date(timeIntervalSince1970: 1721460000), isAvailable: false), // 2024/07/21 10:30 - 11:00
            Timeline(start: Date(timeIntervalSince1970: 1721460000), end: Date(timeIntervalSince1970: 1721461800), isAvailable: true),  // 2024/07/21 11:00 - 11:30
            Timeline(start: Date(timeIntervalSince1970: 1721461800), end: Date(timeIntervalSince1970: 1721463600), isAvailable: false), // 2024/07/21 11:30 - 12:00
            Timeline(start: Date(timeIntervalSince1970: 1721463600), end: Date(timeIntervalSince1970: 1721465400), isAvailable: true),  // 2024/07/21 12:00 - 12:30
            Timeline(start: Date(timeIntervalSince1970: 1721465400), end: Date(timeIntervalSince1970: 1721467200), isAvailable: false), // 2024/07/21 12:30 - 13:00
            Timeline(start: Date(timeIntervalSince1970: 1721467200), end: Date(timeIntervalSince1970: 1721469000), isAvailable: true),  // 2024/07/21 13:00 - 13:30
            Timeline(start: Date(timeIntervalSince1970: 1721469000), end: Date(timeIntervalSince1970: 1721470800), isAvailable: false), // 2024/07/21 13:30 - 14:00
            Timeline(start: Date(timeIntervalSince1970: 1721470800), end: Date(timeIntervalSince1970: 1721472600), isAvailable: true),  // 2024/07/21 14:00 - 14:30
            Timeline(start: Date(timeIntervalSince1970: 1721472600), end: Date(timeIntervalSince1970: 1721474400), isAvailable: false), // 2024/07/21 14:30 - 15:00
            Timeline(start: Date(timeIntervalSince1970: 1721474400), end: Date(timeIntervalSince1970: 1721476200), isAvailable: true),  // 2024/07/21 15:00 - 15:30
            Timeline(start: Date(timeIntervalSince1970: 1721476200), end: Date(timeIntervalSince1970: 1721478000), isAvailable: false), // 2024/07/21 15:30 - 16:00
            Timeline(start: Date(timeIntervalSince1970: 1721478000), end: Date(timeIntervalSince1970: 1721479800), isAvailable: true),  // 2024/07/21 16:00 - 16:30
            Timeline(start: Date(timeIntervalSince1970: 1721479800), end: Date(timeIntervalSince1970: 1721481600), isAvailable: false), // 2024/07/21 16:30 - 17:00
            Timeline(start: Date(timeIntervalSince1970: 1721481600), end: Date(timeIntervalSince1970: 1721483400), isAvailable: true),  // 2024/07/21 17:00 - 17:30
            Timeline(start: Date(timeIntervalSince1970: 1721483400), end: Date(timeIntervalSince1970: 1721485200), isAvailable: false), // 2024/07/21 17:30 - 18:00
            Timeline(start: Date(timeIntervalSince1970: 1721485200), end: Date(timeIntervalSince1970: 1721487000), isAvailable: true),  // 2024/07/21 18:00 - 18:30
            Timeline(start: Date(timeIntervalSince1970: 1721487000), end: Date(timeIntervalSince1970: 1721488800), isAvailable: false), // 2024/07/21 18:30 - 19:00
            Timeline(start: Date(timeIntervalSince1970: 1721488800), end: Date(timeIntervalSince1970: 1721490600), isAvailable: true),  // 2024/07/21 19:00 - 19:30
            Timeline(start: Date(timeIntervalSince1970: 1721490600), end: Date(timeIntervalSince1970: 1721492400), isAvailable: false), // 2024/07/21 19:30 - 20:00
            Timeline(start: Date(timeIntervalSince1970: 1721492400), end: Date(timeIntervalSince1970: 1721494200), isAvailable: true),  // 2024/07/21 20:00 - 20:30
            Timeline(start: Date(timeIntervalSince1970: 1721494200), end: Date(timeIntervalSince1970: 1721496000), isAvailable: false), // 2024/07/21 20:30 - 21:00
            Timeline(start: Date(timeIntervalSince1970: 1721496000), end: Date(timeIntervalSince1970: 1721497800), isAvailable: true),  // 2024/07/21 21:00 - 21:30
            Timeline(start: Date(timeIntervalSince1970: 1721497800), end: Date(timeIntervalSince1970: 1721499600), isAvailable: false), // 2024/07/21 21:30 - 22:00
            Timeline(start: Date(timeIntervalSince1970: 1721499600), end: Date(timeIntervalSince1970: 1721501400), isAvailable: true),  // 2024/07/21 22:00 - 22:30
            Timeline(start: Date(timeIntervalSince1970: 1721501400), end: Date(timeIntervalSince1970: 1721503200), isAvailable: false), // 2024/07/21 22:30 - 23:00
            Timeline(start: Date(timeIntervalSince1970: 1721503200), end: Date(timeIntervalSince1970: 1721505000), isAvailable: true),  // 2024/07/21 23:00 - 23:30
            Timeline(start: Date(timeIntervalSince1970: 1721505000), end: Date(timeIntervalSince1970: 1721506800), isAvailable: false), // 2024/07/21 23:30 - 00:00
            Timeline(start: Date(timeIntervalSince1970: 1721506800), end: Date(timeIntervalSince1970: 1721508600), isAvailable: true),  // 2024/07/22 00:00 - 00:30
            Timeline(start: Date(timeIntervalSince1970: 1721508600), end: Date(timeIntervalSince1970: 1721510400), isAvailable: false), // 2024/07/22 00:30 - 01:00
            Timeline(start: Date(timeIntervalSince1970: 1721510400), end: Date(timeIntervalSince1970: 1721512200), isAvailable: true),  // 2024/07/22 01:00 - 01:30
            Timeline(start: Date(timeIntervalSince1970: 1721512200), end: Date(timeIntervalSince1970: 1721514000), isAvailable: false)  // 2024/07/22 01:30 - 02:00
        ]
        let wakeupTime = Date(timeIntervalSince1970: 1721452800) // 7월 21일 오전 9시
        let bedTime = Date(timeIntervalSince1970: 1721527200) // 7월 22일 오전 2시
    }
    
    // MARK: - Action
    enum Action {
        case tappedEditTimeline
    }
    
    private var _state: State = .init()
    var state: State {
        return _state
    }
    
    // MARK: - View Action
    func effect(_ action: Action) {
        switch action {
        case .tappedEditTimeline:
            _state.editTimeline.toggle()
        }
    }
    
    // MARK: - Helper function
    func timeString(for index: Int) -> String {
        let hour = index / 2 % 24
        let period = hour < 12 ? "오전" : "오후"
        let displayHour = hour % 12 == 0 ? 12 : hour % 12
        return "\(period) \(displayHour)시"
    }
}
