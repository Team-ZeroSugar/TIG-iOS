//
//  SettingRepository.swift
//  TIG
//
//  Created by 이정동 on 7/20/24.
//

import Foundation

protocol AppSettingRepository {
    func setSleepTime(_ sleepTime: SleepTime)
    func getSleetTime() -> SleepTime
    
    func setScreenMode(_ screenMode: Bool)
    func getScreenMode() -> Bool
    
    func setNotification(_ isAllow: Bool)
    func getNotification() -> Bool
    
    func getAppSettings() -> AppSetting
}
