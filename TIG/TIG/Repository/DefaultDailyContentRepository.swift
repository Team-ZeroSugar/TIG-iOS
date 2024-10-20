//
//  SwiftDataService.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import Foundation
import SwiftData

final class DefaultDailyContentRepository {
  
  let modelContext = SwiftDataStorage.shared.modelContext
  
  /// 찾으려는 Entity 데이터가 SwiftData에 존재하는지 확인하고 해당 모델을 반환
  /// - Parameter dailyContent: 변활할 DailyContent 데이터
  /// - Returns: Result<SwiftData에 저장된 DailyContentSD, SwiftDataError>
  private func findSwiftData(
    _ dailyContent: DailyContent
  ) -> Result<DailyContentSD, SwiftDataError> {
    
    let date = dailyContent.date.formattedDate
    let predicate = #Predicate<DailyContentSD> { $0.date == date }
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

// MARK: - DailyContentRepository
extension DefaultDailyContentRepository: DailyContentRepository {
  
  func createDailyContent(_ dailyContent: DailyContent) {
    // Entity -> SwiftData로 매핑
    let model = DailyContentSD(
      date: dailyContent.date.formattedDate,
      timelines: dailyContent.timelines.map {
        TimelineSD(
          start: $0.start.convertToDate(),
          end: $0.end.convertToDate(),
          isAvailable: $0.isAvailable
        )
      },
      totalAvailabilityTime: dailyContent.totalAvailabilityTime
    )
    
    // 추가
    modelContext.insert(model)
  }
  
  func fetchDailyContents() -> Result<[DailyContent], SwiftDataError> {
    do {
      // 조건 지정 (현재 날짜부터)
      let now = Date().formattedDate
      let predicate = #Predicate<DailyContentSD> { $0.date >= now }
      // 정렬 방식 지정 (날짜순)
      let sort = SortDescriptor(\DailyContentSD.date, order: .forward)
      let descriptor = FetchDescriptor(predicate: predicate, sortBy: [sort])
      
      // 데이터 불러오기
      let datas = try modelContext.fetch(descriptor)
      return .success(datas.map { $0.toEntity() })
    } catch {
      return .failure(.fetchError)
    }
  }
  
  func readDailyContent(date: Date) -> Result<DailyContent, SwiftDataError> {
    do {
      let predicate = #Predicate<DailyContentSD> { $0.date == date.formattedDate }
      let descriptor = FetchDescriptor(predicate: predicate)
      
      let datas = try modelContext.fetch(descriptor)
      guard let data = datas.first else { return .failure(.notFound) }
      return .success(data.toEntity())
    } catch {
      return .failure(.fetchError)
    }
  }
  
  func updateDailyContent(dailyContent: DailyContent, timelines: [Timeline]) {
    let result = findSwiftData(dailyContent)
    
    switch result {
    case .success(let model):
      // 기존 모델에 저장된 모든 timeline을 SwiftData에서 삭제
      model.timelines.forEach { modelContext.delete($0) }
      
      // Entity -> SwiftData로 매핑 후 업데이트
      model.timelines = timelines.map {
        TimelineSD(
          start: $0.start.convertToDate(),
          end: $0.end.convertToDate(),
          isAvailable: $0.isAvailable
        )
      }
    case .failure(let error):
      print("Update DailyContent Error: \(error.rawValue)")
    }
  }
  
  func deleteDailyContent(_ dailyContent: DailyContent) {
    let result = findSwiftData(dailyContent)
    
    switch result {
    case .success(let model):
      modelContext.delete(model)
    case .failure(let error):
      print("Delete DailyContent Error: \(error.rawValue)")
    }
  }
}
