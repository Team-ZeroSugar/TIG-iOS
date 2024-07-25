//
//  Date+Edt.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import Foundation

extension Date {
    
    /// M월 d일 EEE
    var pickerFormat: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEE"
        return formatter.string(from: self)
    }
}
