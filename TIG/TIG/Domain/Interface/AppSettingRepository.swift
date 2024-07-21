//
//  SettingRepository.swift
//  TIG
//
//  Created by 이정동 on 7/20/24.
//

import Foundation

protocol AppSettingRepository {
    func updateAppSettings(_ appSetting: AppSetting)
    func getAppSettings() -> AppSetting
}
