//
//  TIGApp.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import SwiftUI

@main
struct TIGApp: App {
  
  @AppStorage(UserDefaultsKey.isOnboarding) private var isOnboarding: Bool = true
  @State private var homeViewModel = HomeViewModel()
  
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
      if !isOnboarding {
        homeViewModel.initData()
      }
    }
  }
}
