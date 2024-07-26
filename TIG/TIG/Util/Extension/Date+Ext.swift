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

    func formattedTimelineTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h시"
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "mm"
        
        let formattedTime = formatter.string(from: self)
        let minutes = minuteFormatter.string(from: self)
        
        if minutes == "00" {
            return formattedTime
        } else {
            return formattedTime + " " + minutes + "분"
        }

    }
}
