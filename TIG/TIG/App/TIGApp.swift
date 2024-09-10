//
//  TIGApp.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import SwiftUI

@main
struct TIGApp: App {

    @State private var homeViewModel = HomeViewModel()
    @StateObject private var appSettings = AppSettings(settings: AppSetting(wakeupTime: Date(), bedTime: Date(), isLightMode: true, allowNotifications: true))
    
    var body: some Scene {
        WindowGroup {
//            OnboardingView()
            HomeView()
                .environment(homeViewModel)
                .environmentObject(appSettings)
                .preferredColorScheme(appSettings.colorScheme)
        }
    }
}
