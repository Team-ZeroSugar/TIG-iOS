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
  @StateObject private var appSettings = AppSettings(settings: AppSetting(wakeupTime: Date(), bedTime: Date(), isLightMode: true, allowNotifications: true))
  
  var body: some Scene {
    WindowGroup {
      
      // TODO: Onboarding 화면에서 HomeViewModel Init이 호출 안되도록 수정 필요
      // HomeViewModel Init에 SwiftData Fetch 코드가 있음
      if isOnboarding {
        OnboardingView()
      } else {
        HomeView()
          .environment(homeViewModel)
          .environmentObject(appSettings)
          .preferredColorScheme(appSettings.colorScheme)
      }
    }
  }
}
