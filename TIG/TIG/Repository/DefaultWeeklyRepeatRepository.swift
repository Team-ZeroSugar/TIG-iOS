//
//  DefaultWeeklyRepeatRepository.swift
//  TIG
//
//  Created by 이정동 on 7/20/24.
//

import Foundation
import SwiftData

final class DefaultWeeklyRepeatRepository {
  
  let modelContext = SwiftDataStorage.shared.modelContext
  
  /// 찾으려는 Entity 데이터가 SwiftData에 존재하는지 확인하고 해당 모델을 반환
  /// - Parameter weeklyRepeat: 변활할 WeeklyRepeat 데이터
  /// - Returns: Result<SwiftData에 저장된 WeeklyRepeatSD, SwiftDataError>
  private func findSwiftData(
    target weeklyRepeat: WeeklyRepeat
  ) -> Result<WeeklyRepeatSD, SwiftDataError> {
    
    let day = weeklyRepeat.day
    let predicate = #Predicate<WeeklyRepeatSD> { $0.day == day }
    let descriptor = FetchDescriptor(predicate: predicate)
    
    do {
      let swiftDatas = try modelContext.fetch(descriptor)
      guard let swiftData = swiftDatas.first else { return .failure(.notFound) }
      return .success(swiftData)
    } catch {
      return .failure(.notFound)
    }
  }
}

extension DefaultWeeklyRepeatRepository: WeeklyRepeatRepository {
  
  /// 일(1) ~ 토(7) 까지의 타임라인 데이터를 초기화
  func initialWeeklyRepeats() {
    (1...7).forEach {
      let model = WeeklyRepeatSD(day: $0, timelines: [])
      modelContext.insert(model)
    }
  }
  
  func fetchWeeklyRepeats() -> Result<[WeeklyRepeat], SwiftDataError> {
    do {
      // 정렬 방식 지정 (요일순)
      let sort = SortDescriptor(\WeeklyRepeatSD.day, order: .forward)
      let descriptor = FetchDescriptor(sortBy: [sort])
      
      // 데이터 불러오기
      let datas = try modelContext.fetch(descriptor)
      return .success(datas.map { $0.toEntity() })
    } catch {
      return .failure(.fetchError)
    }
  }
  
  func readWeelkyRepeat(weekday: Int) -> Result<WeeklyRepeat, SwiftDataError> {
    do {
      let predicate = #Predicate<WeeklyRepeatSD> { $0.day == weekday }
      let descriptor = FetchDescriptor(predicate: predicate)
      
      let datas = try modelContext.fetch(descriptor)
      guard let data = datas.first else { return .failure(.notFound) }
      return .success(data.toEntity())
    } catch {
      return .failure(.fetchError)
    }
  }
  
  func updateWeeklyRepeat(weeklyRepeat: WeeklyRepeat, timelines: [Timeline]) {
    let result = findSwiftData(target: weeklyRepeat)
    
    switch result {
    case .success(let model):
      model.timelines.forEach { modelContext.delete($0) }
      model.timelines = timelines.map {
        TimelineSD(
          start: $0.start.convertToDate(),
          end: $0.end.convertToDate(),
          isAvailable: $0.isAvailable
        )
      }
    case .failure(let error):
      print("Update WeeklyRepeat Error: \(error.rawValue)")
    }
  }
  
  
}
