//
//  DefaultSettingRepository.swift
//  TIG
//
//  Created by 이정동 on 7/20/24.
//

import Foundation

final class DefaultAppSettingRepository {
    
}

extension DefaultAppSettingRepository: AppSettingRepository {
    
    func getSleetTime() -> SleepTime {
        UserDefaults.standard.getSleepTime()
    }
    
    func setSleepTime(_ sleepTime: SleepTime) {
        UserDefaults.standard.setSleepTime(sleepTime)
    }
    
    func getScreenMode() -> Bool {
        UserDefaults.standard.bool(forKey: "screenMode")
    }
    
    func setScreenMode(_ screenMode: Bool) {
        UserDefaults.standard.setValue(screenMode, forKey: "screenMode")
    }
    
    func getNotification() -> Bool {
        UserDefaults.standard.bool(forKey: "notification")
    }
    
    func setNotification(_ isAllow: Bool) {
        UserDefaults.standard.setValue(isAllow, forKey: "notification")
    }
}
