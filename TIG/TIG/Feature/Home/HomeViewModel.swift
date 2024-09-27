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
        
        var remainingTime: String = "0시간 0분"
        // TimelineView
        var isEditMode: Bool = false
        var dailyContent: DailyContent = .init(date: .now, timelines: [], totalAvailabilityTime: 0)
        var weeklyRepeats: [Day: WeeklyRepeat] = [:]
        var appSetting: AppSetting = .init(wakeupTime: .now, bedTime: .now, isLightMode: false, allowNotifications: false)

        // WeeklyRepeatView
        var selectedDay: Day = .sun
        var isRepeatView: Bool = false
    }
    
    private var timer: AnyCancellable?
    
    enum Action {
        // HomeView
        case tabChange(_ tab: Tab)
        case calendarTapped
        case dateTapped(_ date: Date)
        
        // TimelineView
        case editTapped
        case timeSlotTapped(_ index: Int, day: Day?)
        
        // WeeklyRepeatView
        case dayChange(_ day: Day)
        case enterRepeatView
        case exitRepeatView
        
        // AnnounceView
        case settingButtonTapped
      
        // SettingView
        case updateSleepTimeButtonTapped
    }
    
    private(set) var state: State = .init()
  
    private let dailyContentRepository: DailyContentRepository
    private let weeklyRepeatRepository: WeeklyRepeatRepository
    private let settingRepository: AppSettingRepository
  
    init() {
        // TODO: DIContainer 주입으로 수정 필요
        self.dailyContentRepository = DefaultDailyContentRepository()
        self.weeklyRepeatRepository = DefaultWeeklyRepeatRepository()
        self.settingRepository = DefaultAppSettingRepository()
        
//        self.state.dailyContent = self.readDailyContent(.now)
//        self.state.weeklyRepeats = self.readWeeklyRepeats()
//        self.state.appSetting = self.settingRepository.getAppSettings()
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
          self.state.dailyContent = readDailyContent(date)
            
        // TimelineView
        case .editTapped:
            if self.state.isEditMode {
                updateTimeline()
            }
            self.state.isEditMode.toggle()
        case .timeSlotTapped(let index, let day):
            self.toggleTimeSlot(index, day: day)
            
        // WeeklyRepeatView
        case .dayChange(let selectDay):
            self.state.selectedDay = selectDay
        case .enterRepeatView:
            self.state.isEditMode = false
            self.state.isRepeatView = true
        case .exitRepeatView:
            self.state.isEditMode = false
            self.state.isRepeatView = false
            
        // AnnounceView
        case .settingButtonTapped:
            self.state.isEditMode = true
            self.createTimeline()
          
        // SettingView
        case .updateSleepTimeButtonTapped:
          self.state.dailyContent = self.readDailyContent(.now)
        }
    }
  
  func initData() {
    self.state.dailyContent = self.readDailyContent(.now)
    self.state.weeklyRepeats = self.readWeeklyRepeats()
    self.state.appSetting = self.settingRepository.getAppSettings()
    
    startTimer()
  }
}

extension HomeViewModel {
    
    // MARK: - TimelineView Function
    func groupedTimelines(timelines: [Timeline]) -> [(isAvailable: Bool, count: Int, start: DateComponents, end: DateComponents)] {
        var result: [(isAvailable: Bool, count: Int, start: DateComponents, end: DateComponents)] = []
        
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
    
    func toggleTimeSlot(_ index: Int, day: Day?) {
        if day == nil {
            self.state.dailyContent.timelines[index].isAvailable.toggle()
        } else {
            self.state.weeklyRepeats[day!]?.timelines[index].isAvailable.toggle()
        }
    }
    
    func updateTimeline() {
        if self.state.isRepeatView {
            Day.allCases.forEach { day in
                self.weeklyRepeatRepository.updateWeeklyRepeat(weeklyRepeat: state.weeklyRepeats[day]!, timelines: state.weeklyRepeats[day]!.timelines)
            }
            
            let savedDailyContents = self.fetchDailyContents()
            savedDailyContents.forEach { dailyContent in
                let weekday = Calendar.current.component(.weekday, from: dailyContent.date)
                dailyContentRepository.updateDailyContent(dailyContent: dailyContent, timelines: state.weeklyRepeats[Day(rawValue: weekday)!]!.timelines)
            }
            
            self.state.dailyContent = readDailyContent(self.state.currentDate)
        } else {
            self.dailyContentRepository.updateDailyContent(dailyContent: self.state.dailyContent, timelines: self.state.dailyContent.timelines)
        }
    }
    
    //MARK: - TimerView Function
    func currentTimeline() -> (isAvailable: Bool, start: DateComponents, end: DateComponents)? {
        
        let calendar = Calendar.current
        let now = Date()
        
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        let currentTimeInMinutes = hour * 60 + minute
        
        let groupedTimelines = self.groupedTimelines(timelines: state.dailyContent.timelines)
        
        for timeline in groupedTimelines {
            let start = (timeline.start.hour! * 60) + timeline.start.minute!
            let end = (timeline.end.hour! * 60) + timeline.end.minute!
            if currentTimeInMinutes >= start && currentTimeInMinutes <= end {
                return (isAvailable: timeline.isAvailable, start: timeline.start, end: timeline.end)
            }
        }

        return nil
    }
    
    func startTimer() {
        timer = Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTimeAndTimer()
            }
    }
    
    func updateTimeAndTimer() {
        let remainingMinutes = calRemainingAvailableMinutes()
        let totalMinutes = calTotalAvailableMinutes()
        
        state.remainingTime = remainingTime()
        let currentProgress = progress()
    }
    
    func progress() -> CGFloat {
        let totalMinutes = calTotalAvailableMinutes()
        let remainingMinutes = calRemainingAvailableMinutes()
        
        if totalMinutes == 0 { return 0.0 }
        
        return (1 - CGFloat(remainingMinutes) / CGFloat(totalMinutes))
    }
    
    func calTotalAvailableMinutes() -> Int {
        let availableTimelines = state.dailyContent.timelines.filter { $0.isAvailable }
        let totalMinutes = availableTimelines.reduce(0) { result, timeline in
            let start = timeline.start.hour! * 60 + timeline.start.minute!
            let end = timeline.end.hour! * 60 + timeline.end.minute!
            
            return result + (end - start)
        }
        
        return totalMinutes
    }
    
    func calRemainingAvailableMinutes() -> Int {
        if let remainingTime = getRemainingAvailableTime(timelines: state.dailyContent.timelines) {
            let remainingMinutes = (remainingTime.hour ?? 0) * 60 + (remainingTime.minute ?? 0)
            return remainingMinutes
        }
        return 0
    }
    
    func remainingTime() -> String {
        if let remainingTime = getRemainingAvailableTime(timelines: state.dailyContent.timelines) {
            let hours = remainingTime.hour ?? 0
            let minutes = remainingTime.minute ?? 0
            
            let totalMinutes = hours * 60 + minutes
            return totalMinutes.formattedTime()
        } else {
            return "0시간 0분"
        }
    }
    
    func getTotalAvailableTime() -> String {
        let availableCount = state.dailyContent.timelines.filter { $0.isAvailable }.count
        let totalAvailableTime = availableCount * 30
            
        return totalAvailableTime.formattedTime()
    }
    
    func getRemainingAvailableTime(timelines: [Timeline]) -> DateComponents? {
        let now = Calendar.current.dateComponents([.hour, .minute], from: .now)

        let timelines = sortTimelines(timelines)
        
        guard let currentTimelineIndex = timelines.firstIndex(where: { timeline in
            guard let startDate = Calendar.current.date(from: timeline.start),
                  let endDate = Calendar.current.date(from: timeline.end),
                  let nowDate = Calendar.current.date(from: now) else {
                return false
            }
            return startDate <= nowDate && nowDate <= endDate
        }) else {
            return nil
        }
        
        let currentTimeline = timelines[currentTimelineIndex]
        
        var remainingTimeInCurrentTimeline = 0.0
        if currentTimeline.isAvailable {
            guard let endDate = Calendar.current.date(from: currentTimeline.end),
                  let nowDate = Calendar.current.date(from: now) else {
                return nil
            }
            
            remainingTimeInCurrentTimeline = endDate.timeIntervalSince(nowDate) / 60
        }
        
        
        let availableTimeAfterCurrent = Double(timelines.suffix(from: currentTimelineIndex + 1).filter{ $0.isAvailable }.count * 30)
        
        let totalAvailableTimeInMinutes = remainingTimeInCurrentTimeline + availableTimeAfterCurrent
        
        let hours = Int(totalAvailableTimeInMinutes) / 60
        let minutes = Int(totalAvailableTimeInMinutes) % 60
        return DateComponents(hour: hours, minute: minutes)
    }
    
    // MARK: - AnnounceView Function
    func createTimeline() {
        let wakeupTime = UserDefaults.standard.integer(forKey: UserDefaultsKey.wakeupTimeIndex).convertToDateFormat()
        var bedtime = UserDefaults.standard.integer(forKey: UserDefaultsKey.bedTimeIndex).convertToDateFormat()
        let calendar = Calendar.current
        
        var currentTime = wakeupTime
      if wakeupTime > bedtime {
        bedtime.addTimeInterval(86400)
      }
        
        while currentTime < bedtime {
            let nextTime = calendar.date(byAdding: .minute, value: 30, to: currentTime)!
            
            let startComponents = calendar.dateComponents([.day, .hour, .minute], from: currentTime)
            let endComponents = calendar.dateComponents([.day, .hour, .minute], from: nextTime)
            
            if self.state.isRepeatView {
                Day.allCases.forEach { day in
                    self.state.weeklyRepeats[day]?.timelines.append(Timeline(start: startComponents, end: endComponents, isAvailable: true))
                }
            } else {
                self.state.dailyContent.timelines.append(Timeline(start: startComponents, end: endComponents, isAvailable: true))
            }
            
            currentTime = nextTime
        }
        
        
        if self.state.isRepeatView {
            self.weeklyRepeatRepository.initialWeeklyRepeats()
            Day.allCases.forEach { day in
                self.weeklyRepeatRepository.updateWeeklyRepeat(weeklyRepeat: state.weeklyRepeats[day]!, timelines: state.weeklyRepeats[day]!.timelines)
            }
        } else {
            self.dailyContentRepository.createDailyContent(state.dailyContent)
        }
    }
    
}


extension HomeViewModel {
  private func readDailyContent(_ date: Date) -> DailyContent {
    let dailyContentResult = dailyContentRepository.readDailyContent(date: date)
    
    switch dailyContentResult {
    case .success(var dailyContent):
      dailyContent.timelines = sortTimelines(dailyContent.timelines)
      return dailyContent
    case .failure(let error):
      print(error.rawValue)
      let weeklyRepeatResult = weeklyRepeatRepository.readWeelkyRepeat(weekday: date.weekday)
      
      switch weeklyRepeatResult {
      case .success(var weeklyRepeat):
        weeklyRepeat.timelines = sortTimelines(weeklyRepeat.timelines)
        let dailyContent = DailyContent(
          date: date,
          timelines: weeklyRepeat.timelines,
          totalAvailabilityTime: 0
        )
        return dailyContent
      case .failure(let error):
        print(error.rawValue)
        return DailyContent(
          date: date,
          timelines: [],
          totalAvailabilityTime: 0
        )
      }
    }
  }
    
    private func readWeeklyRepeats() -> [Day: WeeklyRepeat] {
        
        var weeklyRepeats: [Day: WeeklyRepeat] = [:]
        
        Day.allCases.forEach { day in
            let weeklyRepeatResult = weeklyRepeatRepository.readWeelkyRepeat(weekday: day.rawValue)
            
            switch weeklyRepeatResult {
            case .success(var weeklyRepeat):
                weeklyRepeat.timelines = sortTimelines(weeklyRepeat.timelines)
                weeklyRepeats[day] = weeklyRepeat
            case .failure(let error):
                print(error.rawValue)
                weeklyRepeats[day] = WeeklyRepeat(day: day.rawValue, timelines: [])
            }
        }
        
        return weeklyRepeats
    }
    
    private func fetchDailyContents() -> [DailyContent] {
        let savedDailyContentsResult = dailyContentRepository.fetchDailyContents()
        
        switch savedDailyContentsResult {
        case .success(let dailyContents):
            return dailyContents
        case .failure(let error):
            print(error.rawValue)
        }
        
        return []
    }
    
    private func sortTimelines(_ timelines: [Timeline]) -> [Timeline] {
        return timelines.sorted {
            if $0.start.hour == $1.start.hour {
                return $0.start.minute ?? 0 < $1.start.minute ?? 0
            }
            return $0.start.hour ?? 0 < $1.start.hour ?? 0
        }
    }
}
