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
    @MainActor func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), dailyContent: getDailyContent())
    }

    @MainActor func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), dailyContent: getDailyContent())
        completion(entry)
    }

    @MainActor func getTimeline(in context: Context, completion: @escaping (WidgetKit.Timeline<Entry>) -> ()) {
        
        let timeline = WidgetKit.Timeline(entries: [SimpleEntry(date: .now, dailyContent: getDailyContent())], policy: .after(.now.advanced(by: 60)))
        completion(timeline)
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
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let dailyContent: DailyContent?
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
                
                Text("5시간 20분")
                    .foregroundStyle(.gray05)
                    .font(.custom(AppFont.semiBold, size: 24))
                
                Spacer().frame(height: 8)
                
                Text("/ 8시간 30분")
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
                Text("5시간 20분")
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
    SimpleEntry(date: .now, dailyContent: nil)
    SimpleEntry(date: .now, dailyContent: nil)
}

