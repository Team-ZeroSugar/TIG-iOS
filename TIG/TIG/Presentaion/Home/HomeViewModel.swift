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
        // HomeView
        var activeTab: Tab = .time
        var isCalendarVisible: Bool = false
        var currentDate: Date = .now
        
        // TimelineView
        var isEditMode: Bool = false
    }
    
    enum Action {
        // HomeView
        case tabChange(_ tab: Tab)
        case calendarTapped
        case dateTapped(_ date: Date)
        
        // TimelineView
        case editTapped
    }
    
    private(set) var state: State = .init()
    
    func effect(_ action: Action) {
        switch action {
        // HomeView
        case .tabChange(let tab):
            self.state.activeTab = tab
        case .calendarTapped:
            self.state.isCalendarVisible.toggle()
        case .dateTapped(let date):
            self.state.currentDate = date
            self.state.isCalendarVisible = false
            
        // TimelineView
        case .editTapped:
            self.state.isEditMode.toggle()
        }
    }
}
