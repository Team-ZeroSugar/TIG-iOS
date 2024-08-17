//
//  AppSetting.swift
//  TIG
//
//  Created by 이정동 on 7/20/24.
//

import Foundation


struct SleepTime: Codable {
    var wakeup: Date
    var bed: Date
}

struct AppSetting: Codable {
    var wakeupTime: Date
    var bedTime: Date
    var isLightMode: Bool
    var allowNotifications: Bool
}
