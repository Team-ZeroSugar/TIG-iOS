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
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 09:00 - 09:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 10, minute: 0))!,
                     isAvailable: false), // 2024/07/21 09:30 - 10:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 10, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 10, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 10:00 - 10:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 10, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 11, minute: 0))!,
                     isAvailable: false), // 2024/07/21 10:30 - 11:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 11, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 11, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 11:00 - 11:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 11, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 12, minute: 0))!,
                     isAvailable: false), // 2024/07/21 11:30 - 12:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 12, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 12, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 12:00 - 12:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 12, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 13, minute: 0))!,
                     isAvailable: false), // 2024/07/21 12:30 - 13:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 13, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 13, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 13:00 - 13:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 13, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 14, minute: 0))!,
                     isAvailable: false), // 2024/07/21 13:30 - 14:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 14, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 14, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 14:00 - 14:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 14, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 15, minute: 0))!,
                     isAvailable: false), // 2024/07/21 14:30 - 15:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 15, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 15, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 15:00 - 15:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 15, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 16, minute: 0))!,
                     isAvailable: false), // 2024/07/21 15:30 - 16:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 16, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 16, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 16:00 - 16:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 16, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 17, minute: 0))!,
                     isAvailable: false), // 2024/07/21 16:30 - 17:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 17, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 17, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 17:00 - 17:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 17, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 18, minute: 0))!,
                     isAvailable: false), // 2024/07/21 17:30 - 18:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 18, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 18, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 18:00 - 18:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 18, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 19, minute: 0))!,
                     isAvailable: false), // 2024/07/21 18:30 - 19:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 19, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 19, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 19:00 - 19:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 19, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 20, minute: 0))!,
                     isAvailable: false), // 2024/07/21 19:30 - 20:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 20, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 20, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 20:00 - 20:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 20, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 21, minute: 0))!,
                     isAvailable: false), // 2024/07/21 20:30 - 21:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 21, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 21, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 21:00 - 21:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 21, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 22, minute: 0))!,
                     isAvailable: false), // 2024/07/21 21:30 - 22:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 22, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 22, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 22:00 - 22:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 22, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 23, minute: 0))!,
                     isAvailable: false), // 2024/07/21 22:30 - 23:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 23, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 23, minute: 30))!,
                     isAvailable: true),  // 2024/07/21 23:00 - 23:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 23, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 0, minute: 0))!,
                     isAvailable: false), // 2024/07/21 23:30 - 00:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 0, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 0, minute: 30))!,
                     isAvailable: true),  // 2024/07/22 00:00 - 00:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 0, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 1, minute: 0))!,
                     isAvailable: false), // 2024/07/22 00:30 - 01:00
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 1, minute: 0))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 1, minute: 30))!,
                     isAvailable: true),  // 2024/07/22 01:00 - 01:30
            Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 1, minute: 30))!,
                     end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 2, minute: 0))!,
                     isAvailable: false)  // 2024/07/22 01:30 - 02:00
        ]
        let wakeupTime = Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 0))! // 7월 21일 오전 9시
        let bedTime = Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 2, minute: 0))! // 7월 22일 오전 2시
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
       
    func filteredTimelines() -> [Timeline] {
        return state.timelines.filter { $0.start >= state.wakeupTime && $0.end <= state.bedTime }
    }
}
