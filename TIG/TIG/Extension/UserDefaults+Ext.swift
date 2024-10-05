//
//  UserDefaults+Ext.swift
//  TIG
//
//  Created by 이정동 on 7/20/24.
//

import Foundation

extension UserDefaults {
    static let appGroupName = "group.com.zerosugar.TIG.appgroup"
    
    static var shared: UserDefaults {
        return UserDefaults(suiteName: appGroupName)!
    }
    
    func setAppSettingData(_ appSetting: AppSetting) {
        if let encodedData = try? JSONEncoder().encode(appSetting) {
            UserDefaults.shared.set(encodedData, forKey: "appSettingData")
       }
    }
    
    func getAppSettingData() -> AppSetting {
        if let savedData = UserDefaults.shared.data(forKey: "appSettingData") {
            if let decodedData = try? JSONDecoder().decode(AppSetting.self, from: savedData) {
                return decodedData
            }
        }
        
        // TODO: 초기 기상, 취침 시간 수정 필요 (기상 : 09시 / 취침 : 24시)
        return AppSetting(wakeupTime: .now, bedTime: .now, isLightMode: true, allowNotifications: false)
    }
}
