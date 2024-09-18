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
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (WidgetKit.Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = WidgetKit.Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
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
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}

