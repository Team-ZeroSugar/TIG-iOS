//
//  DateComponents+Ext.swift
//  TIG
//
//  Created by 이정동 on 8/20/24.
//

import Foundation

extension DateComponents {
    func formattedTimelineTime() -> String? {
        let calendar = Calendar.current
        
        // DateComponents를 Date로 변환
        guard let date = calendar.date(from: self) else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "a h시"
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "mm"
        
        let formattedTime = formatter.string(from: date)
        let minutes = minuteFormatter.string(from: date)
        
        if minutes == "00" {
            return formattedTime
        } else {
            return formattedTime + " " + minutes + "분"
        }
    }
}
