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
    // 위젯이 로드되기 전에 보여줄 기본 데이터
    func placeholder(in context: Context) -> TIGEntry {
        TIGEntry(date: .now, totalAvailabilityTime: 8, remainAvailabilityTime: DateComponents(hour: 4, minute: 30))
    }
    
    // 위젯 미리보기
    func getSnapshot(in context: Context, completion: @escaping (TIGEntry) -> ()) {
        let entry = TIGEntry(date: .now, totalAvailabilityTime: 15, remainAvailabilityTime: DateComponents(hour: 2, minute: 30))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (WidgetKit.Timeline<Entry>) -> ()) {
        
        var entries: [TIGEntry] = []
        
        let dailyContent = getDailyContent()
        if let timelines = dailyContent?.timelines {
            
            
            let currentDate = Date()
            
            for minuteOffset in 0..<5 {
                let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
                
                let totalAvailabilityTime = (timelines.filter { $0.isAvailable }.count)
                
                let remainAvailabilityTime = calRemainingAvailableTime(timelines: timelines, referenceDate: entryDate) ?? DateComponents(hour:0, minute: 0)
                
                print("total: " + totalAvailabilityTime.formattedDuration())
                print("remain: \(remainAvailabilityTime)")
                
                let entry = TIGEntry(date: entryDate, totalAvailabilityTime: totalAvailabilityTime, remainAvailabilityTime: remainAvailabilityTime)
                entries.append(entry)
            }
        } else {
            let entry = TIGEntry(date: .now, totalAvailabilityTime: nil, remainAvailabilityTime: DateComponents(hour:1, minute: 1))
            entries.append(entry)
        }
        
        print(entries)
        let widgetTimeline = WidgetKit.Timeline(entries: entries, policy: .atEnd)
        
        completion(widgetTimeline)
    }
    
    private func getDailyContent() -> DailyContent? {
        let modelContext = SwiftDataStorage.shared.modelContext
        let date: Date = .now
        
        do {
            let predicate = #Predicate<DailyContentSD> { $0.date == date.formattedDate }
            let descriptor = FetchDescriptor(predicate: predicate)
            
            let datas = try modelContext.fetch(descriptor)
            guard let data = datas.first else { return nil }
            return data.toEntity()
        } catch {
            return nil
        }
    }
    
    private func calRemainingAvailableTime(timelines: [Timeline], referenceDate: Date) -> DateComponents? {
        let now = Calendar.current.dateComponents([.hour, .minute], from: referenceDate)
        
        let timelines = sortTimelines(timelines)
        
        guard let currentTimelineIndex = timelines.firstIndex(where: { timeline in
            guard let startDate = Calendar.current.date(from: timeline.start),
                  let endDate = Calendar.current.date(from: timeline.end),
                  let nowDate = Calendar.current.date(from: now) else {
                return false
            }
            return startDate <= nowDate && nowDate <= endDate
        }) else {
            return nil
        }
        
        let currentTimeline = timelines[currentTimelineIndex]
        
        var remainingTimeInCurrentTimeline = 0.0
        if currentTimeline.isAvailable {
            guard let endDate = Calendar.current.date(from: currentTimeline.end),
                  let nowDate = Calendar.current.date(from: now) else {
                return nil
            }
            
            remainingTimeInCurrentTimeline = endDate.timeIntervalSince(nowDate) / 60
        }
        
        
        let availableTimeAfterCurrent = Double(timelines.suffix(from: currentTimelineIndex + 1).filter{ $0.isAvailable }.count * 30)
        
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
    let remainAvailabilityTime: DateComponents
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
                
                
                
                if let totalAvailTime = entry.totalAvailabilityTime {
                    Spacer().frame(height: 12)
                    
                    Text(entry.remainAvailabilityTime.formattedDuration())
                        .foregroundStyle(.gray05)
                        .font(.custom(AppFont.semiBold, size: 24))
                    
                    Spacer().frame(height: 8)
                    
                    Text("/ " + totalAvailTime.formattedDuration())
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
                    
                    if entry.totalAvailabilityTime != nil {
                        Text(entry.remainAvailabilityTime.formattedDuration())
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

