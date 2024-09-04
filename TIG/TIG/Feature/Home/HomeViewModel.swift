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
        var dailyContent: DailyContent = .init(date: .now, timelines: [], totalAvailabilityTime: 0)
        var weeklyRepeats: [Day: WeeklyRepeat] = [:]
        var appSetting: AppSetting = .init(wakeupTime: .now, bedTime: .now, isLightMode: false, allowNotifications: false)

        // RepeatEditView
        var selectedDay: Day = .sun
    }
    
    // TimerView
    private var counter: Int = 0
    private var countTo: Int {
//        if let selectedContent = state.dailyContents.first(where: { Calendar.current.isDate($0.date.formattedDate, inSameDayAs: state.currentDate.formattedDate) }) {
//            return selectedContent.totalAvailabilityTime
//        } else {
//            return 0
//        }
        let content = state.dailyContent
        if content.date.formattedDate == .now.formattedDate {
            return content.totalAvailabilityTime
        } else {
            return 0
        }
    }
    private var timer: AnyCancellable?
    
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
        case resetEditMode
        
        // AnnounceView
        case settingButtonTapped
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
        
        self.state.dailyContent = self.readDailyContent(.now)
        self.state.weeklyRepeats = self.readWeeklyRepeats()
        self.state.appSetting = self.settingRepository.getAppSettings()
        
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
          self.state.dailyContent = readDailyContent(date)
            
        // TimelineView
        case .editTapped:
            self.state.isEditMode.toggle()
        case .timeSlotTapped(let index):
            self.state.dailyContent.timelines[index].isAvailable.toggle()
            
        // RepeatEditView
        case .dayChange(let selectDay):
            self.state.selectedDay = selectDay
        case .resetEditMode:
            self.state.isEditMode = false
            
        // AnnounceView
        case .settingButtonTapped:
            self.createTimeline()
        }
    }
}

extension HomeViewModel {
    
    // MARK: - TimelineView Function
    // timeline배열을 이어진 상태의 뷰를 짤 수 있도록 도와주는 구조로 변경 해주는 함수
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
    
    //MARK: - TimerView Function
    func currentTimeline() -> (isAvailable: Bool, start: DateComponents, end: DateComponents)? {
        
        let calendar = Calendar.current
        let now = Date()
        
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        
        for timeline in state.dailyContent.timelines {
            let start = ((timeline.start.hour! * 60) + timeline.start.minute!)
            let end = ((timeline.end.hour! * 60) + timeline.end.minute!)
            if ((hour * 60) + minute) >= start && ((hour * 60) + minute) <= end {
                return (isAvailable: timeline.isAvailable, start: timeline.start, end: timeline.end)
            }
        }

        return nil
    }
    
    func startTimer() {
        timer = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.incrementCounter()
            }
    }
    
    func incrementCounter() {
        if counter < countTo {
           counter += 60
        }
    }
    
    func progress() -> CGFloat {
        return CGFloat(counter) / CGFloat(countTo)
    }
    
    func remainingTime() -> String {
        let currentTime = countTo - counter
        return currentTime.formattedTime()
    }
    
    func getTotalAvailableTime() -> String {
        let totalAvailableTime = countTo
        return totalAvailableTime.formattedTime()
    }
    
    // MARK: - AnnounceView Function
    func createTimeline() {
//        let wakeupTime = state.appSetting.wakeupTime
//        let bedtime = state.appSetting.bedTime
        let calendar = Calendar.current
        let wakeupTime = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
//        let bedtime = calendar.date(bySettingHour: 2, minute: 0, second: 0, of: Date())!
        let bedtime = calendar.date(bySettingHour: 2, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 1, to: Date())!)!
        
        print(wakeupTime, bedtime)
        
        var currentTime = wakeupTime
        
        while currentTime < bedtime {
            let nextTime = calendar.date(byAdding: .minute, value: 30, to: currentTime)!
            
            let startComponents = calendar.dateComponents([.hour, .minute], from: currentTime)
            let endComponents = calendar.dateComponents([.hour, .minute], from: nextTime)
            
            state.dailyContent.timelines.append(Timeline(start: startComponents, end: endComponents, isAvailable: true))
            
            currentTime = nextTime
        }
        
    }
}

extension HomeViewModel {
  private func readDailyContent(_ date: Date) -> DailyContent {
    let dailyContentResult = dailyContentRepository.readDailyContent(date: date)
    
    switch dailyContentResult {
    case .success(let dailyContent):
      print(dailyContent)
      return dailyContent
    case .failure(let error):
      print(error.rawValue)
      let weeklyRepeatResult = weeklyRepeatRepository.readWeelkyRepeat(weekday: date.weekday)
      
      switch weeklyRepeatResult {
      case .success(let weeklyRepeat):
        print(weeklyRepeat)
        let dailyContent = DailyContent(
          date: date,
          timelines: weeklyRepeat.timelines,
          totalAvailabilityTime: 0
        )
        
        dailyContentRepository.createDailyContent(dailyContent)
        
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
    // weekly의 데이터를 가져올때는 모두 있거나, 모두 없거나?
    
    private func readWeeklyRepeats() -> [Day: WeeklyRepeat] {
        // 1. 일~토의 데이터를 가져오기 시도
        // 1-1. 성공하면 가져와서 데이터 넣기
        // 1-2. 빈 딕셔너리 리턴
        
        var weeklyRepeats: [Day: WeeklyRepeat] = [:]
        
        Day.allCases.forEach { day in
            let weeklyRepeatResult = weeklyRepeatRepository.readWeelkyRepeat(weekday: day.rawValue)
            
            switch weeklyRepeatResult {
            case .success(let weeklyRepeat):
                weeklyRepeats[day] = weeklyRepeat
            case .failure(let error):
                print(error.rawValue)
            }
        }
        
        return weeklyRepeats
    }
}
