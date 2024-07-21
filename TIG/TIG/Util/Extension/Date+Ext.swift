//
//  Date+Edt.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import Foundation

extension Date {
    func formattedTimelineTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h시"
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        return formatter.string(from: self)
    }
}
