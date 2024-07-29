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
        // Data State
        var currentDate: Date = Date()
        var isWeekly: Bool = false
        var wakeupTime: Date = Date()
        var bedTime: Date = Date()
        var timelines: [Timeline] = []
        
        init(currentDate: Date, isWeekly: Bool) {
            self.currentDate = currentDate
            self.isWeekly = isWeekly
        }
    }
    
    // MARK: - Action
    enum Action {
        case tappedEditTimeline
    }
    
    private var appSettingService: AppSettingRepository
    private var dailyDataService: DailyContentRepository
    //private var weeklyDataService: WeeklyRepeatRepository
    private(set) var state: State
    
    init(appSettingService: AppSettingRepository,
         dailyDataService: DailyContentRepository,
         //weeklyDataService: WeeklyRepeatRepository,
         currentDate: Date = Date(),
         isWeelky: Bool = false
    ) {
        self.appSettingService = appSettingService
        self.dailyDataService = dailyDataService
        //self.weeklyDataService = weeklyDataService
        self.state = State(currentDate: currentDate, isWeekly: isWeelky)
        
        let settings = appSettingService.getAppSettings()
        state.wakeupTime = settings.wakeupTime
        state.bedTime = settings.bedTime
        
        if !state.isWeekly {
            updateTimelinesForCurrentDate()
        } else {
            //updateTimelinesForWeeklyReapts()
        }
    }
    
    // MARK: - View Action
    func effect(_ action: Action) {
//        switch action {
//        case .tappedEditTimeline:
//            self.state.editTimeline.toggle()
//        }
    }
    
    // MARK: - Helper function
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

extension TimelineUseCase {
    private func updateTimelinesForCurrentDate() {
        switch dailyDataService.fetchDailyContents() {
        case .success(let dailyContents):
            if let matchingContent = dailyContents.first(where: { Calendar.current.isDate($0.date, inSameDayAs: state.currentDate) }) {
                state.timelines = matchingContent.timelines
            } else {
                state.timelines = []
            }
        case .failure:
            return
        }
    }
    
//    private func updateTimelinesForWeeklyReapts() {
//        switch weeklyDataService.fetchWeeklyRepeats() {
//        case .success(let weeklyContents):
//            print(weeklyContents)
//        case .failure:
//            return
//        }
//    }
}
