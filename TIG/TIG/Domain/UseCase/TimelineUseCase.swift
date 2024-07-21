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
        var timelines: [Timeline] = []
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
