//
//  AppSetting.swift
//  TIG
//
//  Created by 이정동 on 7/20/24.
//

import Foundation
import SwiftUI

struct AppSetting: Codable {
    var wakeupTime: Date // 기상 시간
    var bedTime: Date  // 취침 시간
    var isLightMode: Bool  // 화면 모드
    var allowNotifications: Bool  // 알림 허용 여부
}

class AppSettings: ObservableObject {
    @Published var settings: AppSetting {
        didSet {
            updateColorScheme()
        }
    }
    
    @Published var colorScheme: ColorScheme? = nil
    
    init(settings: AppSetting) {
        self.settings = settings
        self.updateColorScheme()
    }
    
    private func updateColorScheme() {
        colorScheme = settings.isLightMode ? .light : .dark
    }
}
