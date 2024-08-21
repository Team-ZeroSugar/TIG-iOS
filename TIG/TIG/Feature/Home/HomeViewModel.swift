//
//  HomeViewModel.swift
//  TIG
//
//  Created by 이정동 on 7/25/24.
//

import Foundation
import Combine

@Observable
final class HomeViewModel {
    
    struct State {
        // HomeView
        var activeTab: Tab = .time
        var isCalendarVisible: Bool = false
        var currentDate: Date = .now
        
        // TimelineView
        var isEditMode: Bool = false
        var dailyContents: [DailyContent] = TestData.dailycontents
        var timelines: [Timeline] = TestData.dailycontents[0].timelines

        // RepeatEditView
        var selectedDay: Day = .sun
        
        // TimerView
        var counter: Int = 0
        var countTo: Int = 0
        var timer: AnyCancellable?
    }
    
    enum Action {
        // HomeView
        case tabChange(_ tab: Tab)
        case calendarTapped
        case dateTapped(_ date: Date)
        
        // TimelineView
        case editTapped
        case timeSlotTapped(_ index: Int)
        
        // RepeatEditView
        case dayChange(_ day: Day)
    }
    
    private(set) var state: State = .init()
    
    init() {
        startTimer()
    }
    
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
        case .timeSlotTapped(let index):
            self.state.timelines[index].isAvailable.toggle()
            
        // RepeatEditView
        case .dayChange(let selectDay):
            self.state.selectedDay = selectDay
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
              
              // TODO: (Monfi) DateComponents에 맞게 저장
//                result.append((currentIsAvailable, currentCount, currentStart, currentEnd))
                currentIsAvailable = timelines[index].isAvailable
                currentCount = 1
                currentStart = timelines[index].start
                currentEnd = timelines[index].end
            }
        }
        
      // TODO: (Monfi) DateComponents에 맞게 저장
//        result.append((currentIsAvailable, currentCount, currentStart, currentEnd))
        return result
    }
    
    //MARK: - TimerView Function
    func isCurrentTimeAvailable() -> Bool {
        for dailyContent in state.dailyContents {
            for timeline in dailyContent.timelines {
                if let startDate = Calendar.current.date(from: timeline.start), 
                   let endDate = Calendar.current.date(from: timeline.end),
                   timeline.isAvailable && state.currentDate >= startDate && state.currentDate <= endDate {
                    return true
                }
            }
        }
        return false
    }
    
    func startTimer() {
        state.timer = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.incrementCounter()
            }
    }
    
    func incrementCounter() {
        if state.counter < state.countTo {
            state.counter += 60
        }
    }
    
    func progress() -> CGFloat {
        return CGFloat(state.counter) / CGFloat(state.countTo)
    }
    
    func remainingTime() -> String {
        let currentTime = state.countTo - state.counter
        let hours = currentTime / 3600
        let minutes = (currentTime % 3600) / 60
        
        return String(format: "%01d시간 %01d분", hours, minutes)
    }
}
