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
        var timelines: [Timeline] = TestData.dailycontents[0].timelines
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

extension HomeViewModel {
    
    // MARK: - TimelineView Function
    // timeline배열을 이어진 상태의 뷰를 짤 수 있도록 도와주는 구조로 변경 해주는 함수
    func groupedTimelines() -> [(isAvailable: Bool, count: Int, start: Date, end: Date)] {
        var result: [(isAvailable: Bool, count: Int, start: Date, end: Date)] = []
        let timelines = state.timelines
        
        if timelines.isEmpty {
            return result
        }
        
        var currentIsAvailable = timelines[0].isAvailable
        var currentCount = 1
        var currentStart = timelines[0].start
        var currentEnd = timelines[0].end
        
        for index in 1..<timelines.count {
            if timelines[index].isAvailable == currentIsAvailable {
                currentCount += 1
                currentEnd = timelines[index].end
            } else {
                result.append((currentIsAvailable, currentCount, currentStart, currentEnd))
                currentIsAvailable = timelines[index].isAvailable
                currentCount = 1
                currentStart = timelines[index].start
                currentEnd = timelines[index].end
            }
        }
        
        result.append((currentIsAvailable, currentCount, currentStart, currentEnd))
        return result
    }
    
    // TimelineView 시간 표시 함수
    func formattedDuration(from slots: Int) -> String {
        let totalMinutes = slots * 30
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        var result = ""
        if hours > 0 {
            result += "\(hours)시간"
        }
        if minutes > 0 {
            if !result.isEmpty {
                result += " "
            }
            result += "\(minutes)분"
        }
        return result
    }
}
