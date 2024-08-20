//
//  AppSetting.swift
//  TIG
//
//  Created by 이정동 on 7/20/24.
//

import Foundation

struct AppSetting: Codable {
    var wakeupTime: Date // 기상 시간
    var bedTime: Date  // 취침 시간
    var isLightMode: Bool  // 화면 모드
    var allowNotifications: Bool  // 알림 허용 여부
}
