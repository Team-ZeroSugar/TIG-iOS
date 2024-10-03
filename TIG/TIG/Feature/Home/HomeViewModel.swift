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
        
        // TimerView
        var currentTimeline: Timeline?
        var remainingTime: String = "0시간 0분"
        var progress: CGFloat = 0.0
        
        // TimelineView
        var isEditMode: Bool = false
        var dailyContent: DailyContent = .init(date: .now, timelines: [], totalAvailabilityTime: 0)
        var dailyEditingTimelines: [Timeline] = []
        var weeklyRepeats: [Day: WeeklyRepeat] = [:]
        var weeklyEditingTimelines: [Day: [Timeline]] = [:]
        var appSetting: AppSetting = .init(wakeupTime: .now, bedTime: .now, isLightMode: false, allowNotifications: false)

        // WeeklyRepeatView
        var selectedDay: Day = .sun
        var isRepeatView: Bool = false
    }
    
    private var timer: AnyCancellable?
    
    enum Action {
        // HomeView
        case onAppear
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
    }
    
    func effect(_ action: Action) {
        switch action {
        // HomeView
        case .onAppear:
            self.initData()
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
                self.updateTimeline()
                self.updateTimeAndTimer()
            } else {
                self.getEditingTimeline()
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
            self.createNewTimeline()
            self.getEditingTimeline()
          
        // SettingView
        case .updateSleepTimeButtonTapped:
          self.state.dailyContent = self.readDailyContent()
        }
    }
}

extension HomeViewModel {
  
    private func initData() {
      self.state.dailyContent = self.readDailyContent()
      self.state.weeklyRepeats = self.readWeeklyRepeats()
      self.state.appSetting = self.settingRepository.getAppSettings()
      
      startTimer()
    }
    
    // MARK: - TimelineView Function
    func groupedTimelines(timelines: [Timeline]) -> [TimelineGroup] {
        var result: [TimelineGroup] = []
        
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
                result.append(TimelineGroup(
                  start: currentStart,
                  end: currentEnd,
                  isAvailable: currentIsAvailable,
                  count: currentCount
                ))
                currentIsAvailable = timelines[index].isAvailable
                currentCount = 1
                currentStart = timelines[index].start
                currentEnd = timelines[index].end
            }
        }
        
        result.append(TimelineGroup(
          start: currentStart,
          end: currentEnd,
          isAvailable: currentIsAvailable,
          count: currentCount
        ))
          
        return result
    }
    
    private func toggleTimeSlot(_ index: Int, day: Day?) {
        if day == nil {
            self.state.dailyEditingTimelines[index].isAvailable.toggle()
        } else {
            self.state.weeklyEditingTimelines[day!]?[index].isAvailable.toggle()
        }
    }
    
    private func updateTimeline() {
        if self.state.isRepeatView {
            
            var editingDays:[Day] = []
            
            Day.allCases.forEach { day in
                let oldTimelines = self.state.weeklyRepeats[day]!.timelines
                let newTimelines = self.state.weeklyEditingTimelines[day]!
                
                if oldTimelines != newTimelines {
                    
                    editingDays.append(day)
                    
                    self.weeklyRepeatRepository.updateWeeklyRepeat(weeklyRepeat: state.weeklyRepeats[day]!, timelines: newTimelines)
                    self.state.weeklyRepeats[day]!.timelines = newTimelines
                }
            }
            
            let savedDailyContents = self.fetchDailyContents()
            savedDailyContents.forEach { dailyContent in
                let weekday = Calendar.current.component(.weekday, from: dailyContent.date)
                
                if editingDays.contains(Day(rawValue: weekday)!) {
                    dailyContentRepository.updateDailyContent(dailyContent: dailyContent, timelines: state.weeklyEditingTimelines[Day(rawValue: weekday)!]!)
                    self.state.dailyContent.timelines = self.state.weeklyEditingTimelines[Day(rawValue: weekday)!]!
                }
            }
            
        } else {
            self.dailyContentRepository.updateDailyContent(dailyContent: self.state.dailyContent, timelines: self.state.dailyEditingTimelines)
            self.state.dailyContent.timelines = self.state.dailyEditingTimelines
        }
    }
    
  //MARK: - TimerView Function
  func currentTimeline() -> Timeline? {
    
    let groupedTimelines = self.groupedTimelines(timelines: state.dailyContent.timelines)
    
    var nowTime = Calendar.current.dateComponents([.hour, .minute], from: .now).convertTotalMinutes()
    
    let wakeupTime = UserDefaults.standard.integer(forKey: UserDefaultsKey.wakeupTimeIndex) * 30
    var bedTime = UserDefaults.standard.integer(forKey: UserDefaultsKey.bedTimeIndex) * 30
    
    if wakeupTime > bedTime {
        bedTime += 60 * 24
    }
    
    if wakeupTime > nowTime || bedTime <= nowTime {
      nowTime += 60 * 24
    }
    
    for timeline in groupedTimelines {
      let startTime = timeline.start.convertTotalMinutes()
      let endTime = timeline.end.convertTotalMinutes()
      if nowTime >= startTime && nowTime <= endTime {
        return Timeline(
          start: timeline.start,
          end: timeline.end,
          isAvailable: timeline.isAvailable
        )
      }
    }
    
    return nil
  }
  
    private func startTimer() {
      self.updateTimeAndTimer()
      
      timer = Timer.publish(every: 30, on: .main, in: .common)
          .autoconnect()
          .sink { [weak self] _ in
              self?.updateTimeAndTimer()
          }
    }
    
    private func updateTimeAndTimer() {
        let remainingMinutes = getRemainingAvailableTime(timelines: state.dailyContent.timelines)
        let totalMinutes = getTotalAvailableTime()
      
        state.remainingTime = remainingMinutes.formattedTime()
        
        if totalMinutes == 0 {
            state.progress = 0.0
        } else {
            state.progress = 1 - CGFloat(remainingMinutes) / CGFloat(totalMinutes)
        }
    }
  
    func getTotalAvailableTime() -> Int {
        let availableCount = state.dailyContent.timelines.filter { $0.isAvailable }.count
        let totalMinutes = availableCount * 30
        
        return totalMinutes
    }
    
    private func getRemainingAvailableTime(timelines: [Timeline]) -> Int {
      let timelines = sortTimelines(timelines)
              
        var nowTime = Calendar.current.dateComponents([.hour, .minute], from: .now).convertTotalMinutes()
        
        let wakeupTime = UserDefaults.standard.integer(forKey: UserDefaultsKey.wakeupTimeIndex) * 30
        var bedTime = UserDefaults.standard.integer(forKey: UserDefaultsKey.bedTimeIndex) * 30
        
        if wakeupTime > bedTime {
            bedTime += 60 * 24
        }
        
        if wakeupTime > nowTime || bedTime <= nowTime {
            nowTime += 60 * 24
        }
        
        guard let currentTimelineIndex = timelines.firstIndex(where: { timeline in
            let startTime = timeline.start.convertTotalMinutes()
            let endTime = timeline.end.convertTotalMinutes()
            return startTime <= nowTime && nowTime <= endTime
        }) else {
            
            return timelines.filter({ $0.isAvailable }).count * 30
        }
        
        let currentTimeline = timelines[currentTimelineIndex]
        
        var remainingTimeInCurrentTimeline = 0
        if currentTimeline.isAvailable {
            
            let endTime = currentTimeline.end.convertTotalMinutes()
            
            remainingTimeInCurrentTimeline += endTime - nowTime
        }
        
        
        let availableTimeAfterCurrent = timelines.suffix(from: currentTimelineIndex + 1).filter{ $0.isAvailable }.count * 30
        
        let totalAvailableTimeInMinutes = remainingTimeInCurrentTimeline + availableTimeAfterCurrent
        
        
        let hours = Int(totalAvailableTimeInMinutes) / 60
        let minutes = Int(totalAvailableTimeInMinutes) % 60
        
        let totalMinutes = hours * 60 + minutes
        
        return totalMinutes
    }
    
    // MARK: - AnnounceView Function
  private func createNewTimeline() {
      let wakeupTime = UserDefaults.standard.integer(forKey: UserDefaultsKey.wakeupTimeIndex)
      var bedTime = UserDefaults.standard.integer(forKey: UserDefaultsKey.bedTimeIndex)
      
      if wakeupTime > bedTime {
        bedTime += 48
      }
    
      var newTimelines: [Timeline] = []
      
      var currentMinutes = wakeupTime.convertToDateComponents().convertTotalMinutes()
      let endMinutes = bedTime.convertToDateComponents().convertTotalMinutes()
    
      while currentMinutes < endMinutes {
        let nextMinutes = currentMinutes + 30
        
        let start = currentMinutes.convertToDateComponentsFromMinutes()
        let end = nextMinutes.convertToDateComponentsFromMinutes()
        
        newTimelines.append(Timeline(
          start: start,
          end: end,
          isAvailable: true
        ))
        
        currentMinutes = nextMinutes
      }
      
    if self.state.isRepeatView {
        self.weeklyRepeatRepository.initialWeeklyRepeats()
        Day.allCases.forEach { day in
            self.weeklyRepeatRepository.updateWeeklyRepeat(
              weeklyRepeat: state.weeklyRepeats[day]!,
              timelines: newTimelines
            )
            self.state.weeklyRepeats[day]?.timelines = newTimelines
        }
    } else {
        // TODO: 총 가용시간 구하고 저장
        self.dailyContentRepository.createDailyContent(state.dailyContent)
        self.state.dailyContent.timelines = newTimelines
    }
  }
}


extension HomeViewModel {
  
  private func readDailyContent() -> DailyContent {
    let wakeupTimeIndex = UserDefaults.standard.integer(forKey: UserDefaultsKey.wakeupTimeIndex)
    var bedTimeIndex = UserDefaults.standard.integer(forKey: UserDefaultsKey.bedTimeIndex)
    
    if wakeupTimeIndex >= bedTimeIndex {
      bedTimeIndex += 48
    }
    
    let bedDate = bedTimeIndex.convertToDateFormat()
    
    let targetDate = DateManager.shared.getCurrentDailyContentDate(from: bedDate)

    let dailyContent = readDailyContent(targetDate)
    return dailyContent
  }
  
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
    
    private func getEditingTimeline() {
        if self.state.isRepeatView {
            Day.allCases.forEach { day in
                self.state.weeklyEditingTimelines[day] = self.state.weeklyRepeats[day]?.timelines
            }
        } else {
            self.state.dailyEditingTimelines = self.state.dailyContent.timelines
        }
    }
}
