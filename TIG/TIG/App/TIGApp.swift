//
//  TIGApp.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import SwiftUI
import WidgetKit

@main
struct TIGApp: App {
  
  @AppStorage(UserDefaultsKey.isOnboarding, store: UserDefaults(suiteName: "group.com.zerosugar.TIG.appgroup")) private var isOnboarding: Bool = true
  @State private var homeViewModel = HomeViewModel()
    @Environment(\.scenePhase) var scenePhase

  
  var body: some Scene {
    WindowGroup {
      if isOnboarding {
        OnboardingView()
      } else {
        HomeView()
              .environment(homeViewModel)
      }
    }
    .onChange(of: isOnboarding, initial: true) { _, _ in
//      if !isOnboarding {
//        homeViewModel.effect(.onAppear)
//      }
    }
    .onChange(of: scenePhase) { phase, _ in
        switch phase {
        case .active:
            break
        case .inactive:
            WidgetCenter.shared.reloadAllTimelines()
        case .background:
            break
        default:
            print("error")
        }
    }
  }
}
