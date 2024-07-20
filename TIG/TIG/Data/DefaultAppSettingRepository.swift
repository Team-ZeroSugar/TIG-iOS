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
    func updateAppSettings(_ appSetting: AppSetting) {
        UserDefaults.standard.setAppSettingData(appSetting)
    }
    
    func getAppSettings() -> AppSetting {
        UserDefaults.standard.getAppSettingData()
    }
    
    
}
