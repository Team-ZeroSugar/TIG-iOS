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
      print("ModelCOntext Error")
      fatalError(error.localizedDescription)
    }
  }()
}

enum SwiftDataError: String, Error {
  case notFound = "Not Found"
  case fetchError = "Fetch Error"
}
