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
    var dailyContentsResult = dailyContentRepository.fetchDailyContents()
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
    
    var weeklyRepeatResult = weeklyRepeatRepository.fetchWeeklyRepeats()
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
    
    var current = wakeupTime
    let end = bedTime
    
    while current.convertTotalMinutes() < end.convertTotalMinutes() {
      var nextTime = current
      nextTime.minute! += 30
      
      // 만약 60분을 넘으면 한 시간 더하고 분을 0으로 초기화
      if nextTime.minute == 60 {
        nextTime.minute = 0
        nextTime.hour! += 1
      }
      
      // 기존 타임라인 중에 같은 시간이 있는지 확인하고 isAvailable 값을 설정
      let isAvailable = timelines.first(where: {
        $0.start == current
      })?.isAvailable ?? false
      
      newTimelines.append(Timeline(
        start: current,
        end: nextTime,
        isAvailable: isAvailable
      ))
      
      // 다음 타임라인으로 넘어가기
      current = nextTime
    }
    
    return newTimelines
  }
}
