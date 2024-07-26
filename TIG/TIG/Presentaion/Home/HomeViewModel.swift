//
//  HomeViewModel.swift
//  TIG
//
//  Created by 이정동 on 7/25/24.
//

import Foundation

@Observable
final class HomeViewModel {
    
    struct State {
        var activeTab: Tab = .time
        var isCalendarVisible: Bool = false
        var currentDate: Date = .now
    }
    
    enum Action {
        case tabChange(_ tab: Tab)
        case calendarTapped
        case dateTapped(_ date: Date)
    }
    
    private(set) var state: State = .init()
    
    func effect(_ action: Action) {
        switch action {
        case .tabChange(let tab):
            self.state.activeTab = tab
        case .calendarTapped:
            self.state.isCalendarVisible.toggle()
        case .dateTapped(let date):
            self.state.currentDate = date
            self.state.isCalendarVisible = false
        }
    }
}
