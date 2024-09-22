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
    @MainActor func placeholder(in context: Context) -> TIGEntry {
        TIGEntry(date: .now, totalAvailabilityTime: 1, remainAvailabilityTime: DateComponents(hour: 1, minute: 30))
    }
    
    // 위젯 미리보기
    @MainActor func getSnapshot(in context: Context, completion: @escaping (TIGEntry) -> ()) {
        let entry = TIGEntry(date: .now, totalAvailabilityTime: 1, remainAvailabilityTime: DateComponents(hour: 1, minute: 30))
        completion(entry)
    }
    
    @MainActor func getTimeline(in context: Context, completion: @escaping (WidgetKit.Timeline<Entry>) -> ()) {
        
        let dailyContent = getDailyContent()
        let timelines = dailyContent?.timelines
        let totalAvailabilityTime = (timelines?.filter { $0.isAvailable }.count)!
        
        let remainAvailabilityTime = calRemainingAvailableTime(timelines: timelines!) ?? DateComponents(hour:0, minute: 0)
        
        print("total: " + totalAvailabilityTime.formattedDuration())
        print("remain: \(remainAvailabilityTime)")
        
        let widgetTimeline = WidgetKit.Timeline(entries: [TIGEntry(date: .now, totalAvailabilityTime: totalAvailabilityTime, remainAvailabilityTime: remainAvailabilityTime)], policy: .after(.now.advanced(by: 60)))
        completion(widgetTimeline)
    }
    
    @MainActor
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
    
    private func calRemainingAvailableTime(timelines: [Timeline]) -> DateComponents? {
        let now = Calendar.current.dateComponents([.hour, .minute], from: Date())
        
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
        print(currentTimeline)
        
        
        var remainingTimeInCurrentTimeline = 0.0
        if currentTimeline.isAvailable {
            guard let endDate = Calendar.current.date(from: currentTimeline.end),
                  let nowDate = Calendar.current.date(from: now) else {
                return nil
            }
            
            remainingTimeInCurrentTimeline = endDate.timeIntervalSince(nowDate) / 60
        }
        
        
        let availableTimeAfterCurrent = Double(timelines.suffix(from: currentTimelineIndex + 1).filter{ $0.isAvailable }.count * 30)
        print(timelines.suffix(from: currentTimelineIndex + 1))
        
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
    let totalAvailabilityTime: Int
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
                
                Spacer().frame(height: 12)
                
                Text(entry.remainAvailabilityTime.formattedDuration())
                    .foregroundStyle(.gray05)
                    .font(.custom(AppFont.semiBold, size: 24))
                
                Spacer().frame(height: 8)
                
                Text("/ " + entry.totalAvailabilityTime.formattedDuration())
                    .foregroundStyle(.gray05)
                    .font(.custom(AppFont.medium, size: 12))
            }
            
        case .accessoryRectangular:
            VStack(alignment: .leading ,spacing: 2) {
                HStack(spacing: 5.42) {
                    Image("AvailableIcon")
                        .resizable()
                        .frame(width: 14, height: 14)
                    Text("시간가용")
                        .font(.custom(AppFont.semiBold, size: 12))
                    Spacer()
                }
                Text("오늘의 남은 활용 가능 시간")
                Text(entry.remainAvailabilityTime.formattedDuration())
            }.font(.custom(AppFont.medium, size: 13))
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
    TIGEntry(date: .now, totalAvailabilityTime: 1, remainAvailabilityTime: DateComponents(hour: 1, minute: 30))
    TIGEntry(date: .now, totalAvailabilityTime: 1, remainAvailabilityTime: DateComponents(hour: 1, minute: 30))
}

