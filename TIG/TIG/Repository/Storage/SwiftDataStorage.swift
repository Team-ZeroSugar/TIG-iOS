//
//  SwiftDataStorage.swift
//  TIG
//
//  Created by 이정동 on 7/20/24.
//

import Foundation
import SwiftData

final class SwiftDataStorage {
  
  static let shared = SwiftDataStorage()
  private init() {}
  
  let modelContext: ModelContext = {
    let schema = Schema([DailyContentSD.self, WeeklyRepeatSD.self])
    let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
    do {
      let container = try ModelContainer(for: schema, configurations: [configuration])
      return ModelContext(container)
    } catch {
      fatalError(error.localizedDescription)
    }
  }()
}

enum SwiftDataError: Error {
  case notFound
  case fetchError
}
