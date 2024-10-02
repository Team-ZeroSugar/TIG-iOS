//
//  SettingViewModel.swift
//  TIG
//
//  Created by 이정동 on 9/14/24.
//

import Foundation

@Observable
final class SettingViewModel {
  
  struct State {
    
  }
  
  enum Action {
    case updateSleepTimeButtonTapped(Int, Int)
  }
  
  private let dailyContentRepository: DailyContentRepository
  private let weeklyRepeatRepository: WeeklyRepeatRepository
  private let settingRepository: AppSettingRepository
  
  init() {
    self.dailyContentRepository = DefaultDailyContentRepository()
    self.weeklyRepeatRepository = DefaultWeeklyRepeatRepository()
    self.settingRepository = DefaultAppSettingRepository()
  }
  
  func effect(_ action: Action) {
    switch action {
    case let .updateSleepTimeButtonTapped(wakeup, bed):
      self.updateSleepTime(wakeupTimeIndex: wakeup, bedTimeIndex: bed)
    }
  }
  
}

extension SettingViewModel {
  private func updateSleepTime(wakeupTimeIndex: Int, bedTimeIndex: Int) {
    // Int -> DateComponents로 변환
    let wakeupDateComponents = wakeupTimeIndex.convertToDateComponents()
    var bedDateComponents = bedTimeIndex.convertToDateComponents()
    
    if wakeupTimeIndex > bedTimeIndex { bedDateComponents.hour! += 24 }
    
    
    // TODO: 저장된 모든 Timeline들을 가져오기
    // 1. DailyContents의 Timeline
    let dailyContentsResult = dailyContentRepository.fetchDailyContents()
    switch dailyContentsResult {
    case .success(let dailyContents):
      for dailyContent in dailyContents {
        let newTimelines = updatedTimeline(
          timelines: dailyContent.timelines,
          wakeupTime: wakeupDateComponents,
          bedTime: bedDateComponents
        )
        
        dailyContentRepository.updateDailyContent(
          dailyContent: dailyContent,
          timelines: newTimelines
        )
      }
    case .failure(let error):
      print(error)
    }
    
    let weeklyRepeatResult = weeklyRepeatRepository.fetchWeeklyRepeats()
    switch weeklyRepeatResult {
    case .success(let weeklyRepeats):
      for weeklyRepeat in weeklyRepeats {
        let newTimelines = updatedTimeline(
          timelines: weeklyRepeat.timelines,
          wakeupTime: wakeupDateComponents,
          bedTime: bedDateComponents
        )
        
        weeklyRepeatRepository.updateWeeklyRepeat(
          weeklyRepeat: weeklyRepeat,
          timelines: newTimelines
        )
      }
    case .failure(let error):
      print(error)
    }
    
    // 수면시간 데이터 업데이트
    UserDefaults.standard.set(wakeupTimeIndex, forKey: UserDefaultsKey.wakeupTimeIndex)
    UserDefaults.standard.set(bedTimeIndex, forKey: UserDefaultsKey.bedTimeIndex)
  }
  
  private func updatedTimeline(
    timelines: [Timeline],
    wakeupTime: DateComponents,
    bedTime: DateComponents
  ) -> [Timeline] {
    var newTimelines: [Timeline] = []
    
    if timelines.isEmpty { return [] }
    
    var currentMinutes = wakeupTime.convertTotalMinutes()
    let endMinutes = bedTime.convertTotalMinutes()
    
    while currentMinutes < endMinutes {
      let nextMinutes = currentMinutes + 30
      
      let isAvailable = timelines.first(where: {
        $0.start.convertTotalMinutes() == currentMinutes
      })?.isAvailable ?? false
      
      let start = currentMinutes.convertToDateComponentsFromMinutes()
      let end = nextMinutes.convertToDateComponentsFromMinutes()
      
      newTimelines.append(Timeline(
        start: start,
        end: end,
        isAvailable: isAvailable
      ))
      
      currentMinutes = nextMinutes
    }
    
    return newTimelines
  }
}
