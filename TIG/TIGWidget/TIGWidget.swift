//
//  TIGWidget.swift
//  TIGWidget
//
//  Created by 신승재 on 8/21/24.
//

import WidgetKit
import SwiftUI
import SwiftData

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
        
        if let dailyContent = getDailyContent() {
            
            let currentDate = Date()
            
            for minuteOffset in 0..<5 {
                let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
                
                let totalAvailabilityTime = (dailyContent.timelines.filter { $0.isAvailable }.count)
                
                let remainAvailabilityTime = calRemainingAvailableTime(dailyContent: dailyContent, referenceDate: entryDate) ?? DateComponents(hour:0, minute: 0)
                
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
    
    private func getDailyContent() -> DailyContent? {
        let dailyContentRepository = DefaultDailyContentRepository()
        let savedDailyContentsResult = dailyContentRepository.fetchDailyContents()
        
        switch savedDailyContentsResult {
        case .success(let dailyContents):
            return dailyContents[0]
        case .failure(let error):
            print(error.rawValue)
        }
        
        return nil
    }
    
    private func calRemainingAvailableTime(dailyContent: DailyContent, referenceDate: Date) -> DateComponents? {
        
        // 26일의 데이터
        // 극단적인 가정 -> 기상시간 새벽 4시, 취침시간 새벽 2시
        
        // 현재시간이 27일 새벽 1시(타임라인에 포함 O)
        // 26일의 데이터
        // now -> hour: 25, minute: 0
        
        // 현재시간이 27일 새벽 3시(타임라인에 포함 X)
        // 27일의 데이터(취침시간이 하루가 넘어갈 경우, now의 날짜 데이터를 표시)
        // now -> hour: 3, minute: 0
        
        // 일반적인 가정 -> 기상시간 오전 8시, 취침시간 오후 12시
        // 26일의 데이터
        // 현재시간이 27일 새벽 1시
        // now -> hour: 1
        
        // 가지고 있는 timeline 데이터가 제대로 된 데이터라고 가정했을때
        // now 에 들어갈 시간은?
        
        // 기상 ~ 취침시간에 포함되고 dailycontents의 날짜의 다음날이다 -> + 24시간
        // 기상 ~ 취침시간에 미포함되고 dailycontents의 날짜의 다음날이다 -> 그대로 표시
        
        // 기상 ~ 취침시간에 포함되고 dailycontents와 같은 날이다 -> 그대로 표시
        // 기상 ~ 취침시간에 미포함되고 dailycontents와 같은 날이다 -> 그대로 표시
        
        let wakeupTime = UserDefaults.standard.integer(forKey: UserDefaultsKey.wakeupTimeIndex) * 30
        var bedTime = UserDefaults.standard.integer(forKey: UserDefaultsKey.bedTimeIndex) * 30
        
        if wakeupTime > bedTime {
            bedTime += 24 * 60
        }
        
        // TODO: 현재시간 표시하기
//        let nowTime = Calendar.current.dateComponents([.hour, .minute], from: referenceDate).convertTotalMinutes()
        let nowDate = referenceDate
        var nowTime = Calendar.current.dateComponents([.hour, .minute], from: nowDate).convertTotalMinutes()
        
        let isSameDay = Calendar.current.isDate(dailyContent.date, equalTo: nowDate, toGranularity: .day)
        
        if !isSameDay && (wakeupTime <= nowTime && bedTime > nowTime) {
            nowTime += 24 * 60
        }
        

        
        let timelines = sortTimelines(dailyContent.timelines)
        
        guard let currentTimelineIndex = timelines.firstIndex(where: { timeline in
            let startTime = timeline.start.convertTotalMinutes()
            let endTime = timeline.end.convertTotalMinutes()
            return startTime <= nowTime && nowTime <= endTime
        }) else {
            return nil
        }
        
        let currentTimeline = timelines[currentTimelineIndex]
        
        var remainingTimeInCurrentTimeline = 0
        if currentTimeline.isAvailable {
            
            let endTime = currentTimeline.end.convertTotalMinutes()
            
            remainingTimeInCurrentTimeline += endTime - nowTime
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
                
                
                
                if let totalAvailTime = entry.totalAvailabilityTime, let remainAvailTime = entry.remainAvailabilityTime {
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
            if #available(iOS 17.0, *) {
                TIGWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TIGWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .accessoryRectangular])
    }
}

#Preview(as: .systemSmall) {
    TIGWidget()
} timeline: {
    TIGEntry(date: .now, totalAvailabilityTime: 8, remainAvailabilityTime: DateComponents(hour: 4, minute: 30))
    TIGEntry(date: .now, totalAvailabilityTime: 8, remainAvailabilityTime: DateComponents(hour: 4, minute: 30))
}

