//
//  TestData.swift
//  TIG
//
//  Created by 신승재 on 7/29/24.
//

import Foundation

//struct TestData {
//    static let timelines: [Timeline] = [
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 30))!,
//                         isAvailable: true),  // 2024/07/21 09:00 - 09:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 10, minute: 0))!,
//                         isAvailable: true), // 2024/07/21 09:30 - 10:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 10, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 10, minute: 30))!,
//                         isAvailable: true),  // 2024/07/21 10:00 - 10:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 10, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 11, minute: 0))!,
//                         isAvailable: true), // 2024/07/21 10:30 - 11:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 11, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 11, minute: 30))!,
//                         isAvailable: true),  // 2024/07/21 11:00 - 11:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 11, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 12, minute: 0))!,
//                         isAvailable: false), // 2024/07/21 11:30 - 12:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 12, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 12, minute: 30))!,
//                         isAvailable: true),  // 2024/07/21 12:00 - 12:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 12, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 13, minute: 0))!,
//                         isAvailable: true), // 2024/07/21 12:30 - 13:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 13, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 13, minute: 30))!,
//                         isAvailable: true),  // 2024/07/21 13:00 - 13:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 13, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 14, minute: 0))!,
//                         isAvailable: true), // 2024/07/21 13:30 - 14:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 14, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 14, minute: 30))!,
//                         isAvailable: true),  // 2024/07/21 14:00 - 14:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 14, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 15, minute: 0))!,
//                         isAvailable: true), // 2024/07/21 14:30 - 15:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 15, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 15, minute: 30))!,
//                         isAvailable: true),  // 2024/07/21 15:00 - 15:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 15, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 16, minute: 0))!,
//                         isAvailable: false), // 2024/07/21 15:30 - 16:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 16, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 16, minute: 30))!,
//                         isAvailable: true),  // 2024/07/21 16:00 - 16:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 16, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 17, minute: 0))!,
//                         isAvailable: false), // 2024/07/21 16:30 - 17:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 17, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 17, minute: 30))!,
//                         isAvailable: true),  // 2024/07/21 17:00 - 17:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 17, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 18, minute: 0))!,
//                         isAvailable: false), // 2024/07/21 17:30 - 18:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 18, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 18, minute: 30))!,
//                         isAvailable: false),  // 2024/07/21 18:00 - 18:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 18, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 19, minute: 0))!,
//                         isAvailable: false), // 2024/07/21 18:30 - 19:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 19, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 19, minute: 30))!,
//                         isAvailable: false),  // 2024/07/21 19:00 - 19:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 19, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 20, minute: 0))!,
//                         isAvailable: false), // 2024/07/21 19:30 - 20:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 20, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 20, minute: 30))!,
//                         isAvailable: false),  // 2024/07/21 20:00 - 20:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 20, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 21, minute: 0))!,
//                         isAvailable: false), // 2024/07/21 20:30 - 21:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 21, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 21, minute: 30))!,
//                         isAvailable: false),  // 2024/07/21 21:00 - 21:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 21, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 22, minute: 0))!,
//                         isAvailable: false), // 2024/07/21 21:30 - 22:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 22, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 22, minute: 30))!,
//                         isAvailable: false),  // 2024/07/21 22:00 - 22:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 22, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 23, minute: 0))!,
//                         isAvailable: false), // 2024/07/21 22:30 - 23:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 23, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 23, minute: 30))!,
//                         isAvailable: true),  // 2024/07/21 23:00 - 23:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 23, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 0, minute: 0))!,
//                         isAvailable: true), // 2024/07/21 23:30 - 00:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 0, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 0, minute: 30))!,
//                         isAvailable: true),  // 2024/07/22 00:00 - 00:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 0, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 1, minute: 0))!,
//                         isAvailable: true), // 2024/07/22 00:30 - 01:00
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 1, minute: 0))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 1, minute: 30))!,
//                         isAvailable: true),  // 2024/07/22 01:00 - 01:30
//                Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 1, minute: 30))!,
//                         end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 2, minute: 0))!,
//                         isAvailable: false)  // 2024/07/22 01:30 - 02:00
//            ]
//    
//    static let dailycontents = [
//        DailyContent(date: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 0))!, timelines: timelines, totalAvailabilityTime: 8),
//    ]
//}

struct TestData {
    static let timelines: [Timeline] = [
                Timeline(start: DateComponents(hour: 9, minute: 0),
                         end: DateComponents(hour: 9, minute: 30),
                         isAvailable: true),  // 09:00 - 09:30
                Timeline(start: DateComponents(hour: 9, minute: 30),
                         end: DateComponents(hour: 10, minute: 0),
                         isAvailable: true), // 09:30 - 10:00
                Timeline(start: DateComponents(hour: 10, minute: 0),
                         end: DateComponents(hour: 10, minute: 30),
                         isAvailable: true),  // 10:00 - 10:30
                Timeline(start: DateComponents(hour: 10, minute: 30),
                         end: DateComponents(hour: 11, minute: 0),
                         isAvailable: true), // 10:30 - 11:00
                Timeline(start: DateComponents(hour: 11, minute: 0),
                         end: DateComponents(hour: 11, minute: 30),
                         isAvailable: true),  // 11:00 - 11:30
                Timeline(start: DateComponents(hour: 11, minute: 30),
                         end: DateComponents(hour: 12, minute: 0),
                         isAvailable: false), // 11:30 - 12:00
                Timeline(start: DateComponents(hour: 12, minute: 0),
                         end: DateComponents(hour: 12, minute: 30),
                         isAvailable: true),  // 12:00 - 12:30
                Timeline(start: DateComponents(hour: 12, minute: 30),
                         end: DateComponents(hour: 13, minute: 0),
                         isAvailable: true), // 12:30 - 13:00
                Timeline(start: DateComponents(hour: 13, minute: 0),
                         end: DateComponents(hour: 13, minute: 30),
                         isAvailable: true),  // 13:00 - 13:30
                Timeline(start: DateComponents(hour: 13, minute: 30),
                         end: DateComponents(hour: 14, minute: 0),
                         isAvailable: true), // 13:30 - 14:00
                Timeline(start: DateComponents(hour: 14, minute: 0),
                         end: DateComponents(hour: 14, minute: 30),
                         isAvailable: true),  // 14:00 - 14:30
                Timeline(start: DateComponents(hour: 14, minute: 30),
                         end: DateComponents(hour: 15, minute: 0),
                         isAvailable: true), // 14:30 - 15:00
                Timeline(start: DateComponents(hour: 15, minute: 0),
                         end: DateComponents(hour: 15, minute: 30),
                         isAvailable: true),  // 15:00 - 15:30
                Timeline(start: DateComponents(hour: 15, minute: 30),
                         end: DateComponents(hour: 16, minute: 0),
                         isAvailable: false), // 15:30 - 16:00
                Timeline(start: DateComponents(hour: 16, minute: 0),
                         end: DateComponents(hour: 16, minute: 30),
                         isAvailable: true),  // 16:00 - 16:30
                Timeline(start: DateComponents(hour: 16, minute: 30),
                         end: DateComponents(hour: 17, minute: 0),
                         isAvailable: false), // 16:30 - 17:00
                Timeline(start: DateComponents(hour: 17, minute: 0),
                         end: DateComponents(hour: 17, minute: 30),
                         isAvailable: true),  // 17:00 - 17:30
                Timeline(start: DateComponents(hour: 17, minute: 30),
                         end: DateComponents(hour: 18, minute: 0),
                         isAvailable: false), // 17:30 - 18:00
                Timeline(start: DateComponents(hour: 18, minute: 0),
                         end: DateComponents(hour: 18, minute: 30),
                         isAvailable: false),  // 18:00 - 18:30
                Timeline(start: DateComponents(hour: 18, minute: 30),
                         end: DateComponents(hour: 19, minute: 0),
                         isAvailable: false), // 18:30 - 19:00
                Timeline(start: DateComponents(hour: 19, minute: 0),
                         end: DateComponents(hour: 19, minute: 30),
                         isAvailable: false),  // 19:00 - 19:30
                Timeline(start: DateComponents(hour: 19, minute: 30),
                         end: DateComponents(hour: 20, minute: 0),
                         isAvailable: false), // 19:30 - 20:00
                Timeline(start: DateComponents(hour: 20, minute: 0),
                         end: DateComponents(hour: 20, minute: 30),
                         isAvailable: false),  // 20:00 - 20:30
                Timeline(start: DateComponents(hour: 20, minute: 30),
                         end: DateComponents(hour: 21, minute: 0),
                         isAvailable: false), // 20:30 - 21:00
                Timeline(start: DateComponents(hour: 21, minute: 0),
                         end: DateComponents(hour: 21, minute: 30),
                         isAvailable: false),  // 21:00 - 21:30
                Timeline(start: DateComponents(hour: 21, minute: 30),
                         end: DateComponents(hour: 22, minute: 0),
                         isAvailable: false), // 21:30 - 22:00
                Timeline(start: DateComponents(hour: 22, minute: 0),
                         end: DateComponents(hour: 22, minute: 30),
                         isAvailable: false),  // 22:00 - 22:30
                Timeline(start: DateComponents(hour: 22, minute: 30),
                         end: DateComponents(hour: 23, minute: 0),
                         isAvailable: false), // 22:30 - 23:00
                Timeline(start: DateComponents(hour: 23, minute: 0),
                         end: DateComponents(hour: 23, minute: 30),
                         isAvailable: true),  // 23:00 - 23:30
                Timeline(start: DateComponents(hour: 23, minute: 30),
                         end: DateComponents(hour: 24, minute: 0),
                         isAvailable: true), // 23:30 - 00:00
                Timeline(start: DateComponents(hour: 24, minute: 0),
                         end: DateComponents(hour: 24, minute: 30),
                         isAvailable: true),  // 00:00 - 00:30
                Timeline(start: DateComponents(hour: 24, minute: 30),
                         end: DateComponents(hour: 25, minute: 0),
                         isAvailable: true), // 00:30 - 01:00
                Timeline(start: DateComponents(hour: 25, minute: 0),
                         end: DateComponents(hour: 25, minute: 30),
                         isAvailable: true),  // 01:00 - 01:30
                Timeline(start: DateComponents(hour: 25, minute: 30),
                         end: DateComponents(hour: 26, minute: 0),
                         isAvailable: false)  // 01:30 - 02:00
            ]
    
    static let dailycontents = [
      DailyContent(date: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 0))!, timelines: timelines, totalAvailabilityTime: 8)
    ]
}
