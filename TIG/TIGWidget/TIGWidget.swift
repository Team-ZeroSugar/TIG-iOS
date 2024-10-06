//
//  TIGWidget.swift
//  TIGWidget
//
//  Created by 신승재 on 8/21/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TIGEntry {
        TIGEntry(date: .now, totalAvailabilityTime: 8, remainAvailabilityTime: DateComponents(hour: 4, minute: 30))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TIGEntry) -> ()) {
        let entry = TIGEntry(date: .now, totalAvailabilityTime: 15, remainAvailabilityTime: DateComponents(hour: 2, minute: 30))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (WidgetKit.Timeline<Entry>) -> ()) {
        
        var entries: [TIGEntry] = []
        
        let timelines = getDailyContent().timelines
        
        if !timelines.isEmpty {
            
            let currentDate = Date()
            
            for minuteOffset in 0..<5 {
                let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
                
                let totalAvailabilityTime = (timelines.filter { $0.isAvailable }.count)
                
                let remainAvailabilityTime = calRemainingAvailableTime(timelines: timelines, referenceDate: entryDate) ?? DateComponents(hour:0, minute: 0)
                
                let entry = TIGEntry(date: entryDate, totalAvailabilityTime: totalAvailabilityTime, remainAvailabilityTime: remainAvailabilityTime)
                entries.append(entry)
            }
        } else {
            let entry = TIGEntry(date: .now, totalAvailabilityTime: nil, remainAvailabilityTime: nil)
            entries.append(entry)
        }
        
        let widgetTimeline = WidgetKit.Timeline(entries: entries, policy: .atEnd)
        
        completion(widgetTimeline)
    }
    
//    private func getDailyContent() -> DailyContent? {
//        let targetDate = DateManager.shared.getCurrentDailyContentDate()
//        let dailyContent = readDailyContent(targetDate)
//        return dailyContent
//    }
    
    private func getDailyContent() -> DailyContent {
        let dailyContentRepository = DefaultDailyContentRepository()
        let weeklyRepeatRepository = DefaultWeeklyRepeatRepository()
        let targetDate = DateManager.shared.getCurrentDailyContentDate()
        
        let dailyContentResult = dailyContentRepository.readDailyContent(date: targetDate)
        
        switch dailyContentResult {
        case .success(var dailyContent):
            dailyContent.timelines = sortTimelines(dailyContent.timelines)
            return dailyContent
        case .failure(let error):
            print(error.rawValue)
            let weeklyRepeatResult = weeklyRepeatRepository.readWeelkyRepeat(weekday: targetDate.weekday)
            
            switch weeklyRepeatResult {
            case .success(var weeklyRepeat):
                weeklyRepeat.timelines = sortTimelines(weeklyRepeat.timelines)
                let dailyContent = DailyContent(
                    date: targetDate,
                    timelines: weeklyRepeat.timelines,
                    totalAvailabilityTime: 0
                )
                return dailyContent
            case .failure(let error):
                print(error.rawValue)
                return DailyContent(
                    date: targetDate,
                    timelines: [],
                    totalAvailabilityTime: 0
                )
            }
        }
    }
    
    private func calRemainingAvailableTime(timelines: [Timeline], referenceDate: Date) -> DateComponents? {
        
        let timelines = sortTimelines(timelines)
        
        var referenceTime = Calendar.current.dateComponents([.hour, .minute], from: referenceDate).convertTotalMinutes()
        
        let wakeupTime = (timelines.first?.start.convertTotalMinutes())!
        let bedTime = (timelines.last?.end.convertTotalMinutes())!
        
        if wakeupTime > referenceTime || bedTime <= referenceTime {
            referenceTime += 60 * 24
        }
        
        guard let currentTimelineIndex = timelines.firstIndex(where: { timeline in
            let startTime = timeline.start.convertTotalMinutes()
            let endTime = timeline.end.convertTotalMinutes()
            return startTime <= referenceTime && referenceTime <= endTime
        }) else {
            
            let totalAvailableTimeInMinutes = timelines.filter({ $0.isAvailable }).count * 30
            
            let hours = Int(totalAvailableTimeInMinutes) / 60
            let minutes = Int(totalAvailableTimeInMinutes) % 60
            
            return DateComponents(hour: hours, minute: minutes)
        }
        
        let currentTimeline = timelines[currentTimelineIndex]
        
        var remainingTimeInCurrentTimeline = 0
        if currentTimeline.isAvailable {
            
            let endTime = currentTimeline.end.convertTotalMinutes()
            
            remainingTimeInCurrentTimeline += endTime - referenceTime
        }
        
        
        let availableTimeAfterCurrent = timelines.suffix(from: currentTimelineIndex + 1).filter{ $0.isAvailable }.count * 30
        
        let totalAvailableTimeInMinutes = remainingTimeInCurrentTimeline + availableTimeAfterCurrent
        
        let hours = Int(totalAvailableTimeInMinutes) / 60
        let minutes = Int(totalAvailableTimeInMinutes) % 60
        
        return DateComponents(hour: hours, minute: minutes)
    }
    
    private func sortTimelines(_ timelines: [Timeline]) -> [Timeline] {
        return timelines.sorted {
            if $0.start.hour == $1.start.hour {
                return $0.start.minute ?? 0 < $1.start.minute ?? 0
            }
            return $0.start.hour ?? 0 < $1.start.hour ?? 0
        }
    }
}

struct TIGEntry: TimelineEntry {
    let date: Date
    let totalAvailabilityTime: Int?
    let remainAvailabilityTime: DateComponents?
}

struct TIGWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.blueMain)
                        .frame(width: 97, height: 22)
                    
                    Text("남은 활용 가능 시간")
                        .foregroundStyle(.darkWhite)
                        .font(.custom(AppFont.medium, size: 10))
                }
                
                
                
                if let totalAvailTime = entry.totalAvailabilityTime, 
                   let remainAvailTime = entry.remainAvailabilityTime {
                    Spacer().frame(height: 12)
                    
                    Text(remainAvailTime.formattedFullDuration())
                        .foregroundStyle(.gray05)
                        .font(.custom(AppFont.semiBold, size: 24))
                    
                    Spacer().frame(height: 8)
                    
                    Text("/ " + totalAvailTime.formattedFullDuration())
                        .foregroundStyle(.gray05)
                        .font(.custom(AppFont.medium, size: 12))
                } else {
                    Spacer().frame(height: 20)
                    
                    Text("오늘 일정을 설정하여\n남은 시간을 확인해 보세요!")
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .foregroundStyle(.gray05)
                        .font(.custom(AppFont.medium, size: 11))
                }
            }
            
        case .accessoryRectangular:
            HStack {
                VStack(alignment: .leading ,spacing: 2) {
                    Text("남은 활용 가능 시간")
                        .font(.custom(AppFont.medium, size: 13))
                    
                    if let remainAvailTime = entry.remainAvailabilityTime {
                        Text(remainAvailTime.formattedFullDuration())
                            .font(.custom(AppFont.bold, size: 16))
                    } else {
                        Text("설정 필요")
                            .font(.custom(AppFont.medium, size: 16))
                    }
                }
                
                Spacer()
            }
        default:
            VStack {}
        }
    }
}

struct TIGWidget: Widget {
    let kind: String = "TIGWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            if #available(iOS 17.0, *) {
                TIGWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
//            } else {
//                TIGWidgetEntryView(entry: entry)
//                    .padding()
//                    .background()
//            }
        }
        .configurationDisplayName("남은 활용 가능 시간")
        .description("오늘 활용할 수 있는 총 시간과\n 남은 활용 가능 시간을 표시합니다.")
        .supportedFamilies([.systemSmall, .accessoryRectangular])
    }
}

#Preview(as: .systemSmall) {
    TIGWidget()
} timeline: {
    TIGEntry(date: .now, totalAvailabilityTime: 8, remainAvailabilityTime: DateComponents(hour: 4, minute: 30))
    TIGEntry(date: .now, totalAvailabilityTime: 8, remainAvailabilityTime: DateComponents(hour: 4, minute: 30))
}

