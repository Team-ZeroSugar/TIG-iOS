//
//  UserDefaults+Ext.swift
//  TIG
//
//  Created by 이정동 on 7/20/24.
//

import Foundation

extension UserDefaults {
    func setAppSettingData(_ appSetting: AppSetting) {
        if let encodedData = try? JSONEncoder().encode(appSetting) {
           self.set(encodedData, forKey: "appSettingData")
       }
    }
    
    func getAppSettingData() -> AppSetting {
        if let savedData = self.data(forKey: "appSettingData") {
            if let decodedData = try? JSONDecoder().decode(AppSetting.self, from: savedData) {
                return decodedData
            }
        }
        
        // TODO: 초기 기상, 취침 시간 수정 필요 (기상 : 09시 / 취침 : 24시)
        return AppSetting(wakeupTime: .now, bedTime: .now, isLightMode: true, allowNotifications: false)
    }
}
