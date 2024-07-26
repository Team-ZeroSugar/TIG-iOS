//
//  TimeLineView.swift
//  TIG
//
//  Created by 신승재 on 7/19/24.
//

import SwiftUI

struct TimelineView: View {
    //    // homeViewModel에 저장된 DailyContent를 가지고 계산 필요
    //    @Environment(HomeViewModel.self) var homeViewModel
    
    @State var timelineUseCase: TimelineUseCase
    
    init(timelineUseCase: TimelineUseCase) {
        self.timelineUseCase = timelineUseCase
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer().frame(height: 47)
                
                TimelineHeaderView(timelineUseCase: timelineUseCase)
                
                Spacer().frame(height: 51)
                
                TimelineBodyView(timelineUseCase: timelineUseCase)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Header View
fileprivate struct TimelineHeaderView: View {
    var timelineUseCase: TimelineUseCase
    
    fileprivate var body: some View {
        HStack {
            Text(timelineUseCase.state.editTimeline ? "오늘 일정 시간을 탭해서 지워주세요" : "지금은 활용 가능 시간이에요")
                .font(.custom(AppFont.semiBold, size: 18))
                .foregroundStyle(AppColor.gray5)
            
            Spacer()
            
            Button(action: {
                timelineUseCase.effect(.tappedEditTimeline)
            }, label: {
                Text(timelineUseCase.state.editTimeline ? "완료" : "편집")
                    .font(.custom(AppFont.medium, size: 16))
                    .foregroundStyle(AppColor.mainBlue)
            })
        }
    }
}

// MARK: - Body View
fileprivate struct TimelineBodyView: View {
    
    var timelineUseCase: TimelineUseCase

    fileprivate var body: some View {
        
        HStack(spacing: 0) {

            TimeMarkerView(timelineUseCase: timelineUseCase)
            
            Spacer().frame(width: 18)
            
            TimelineContentView(timelineUseCase: timelineUseCase)
            
        }
    }
}

// MARK: - TimeMarkerView
fileprivate struct TimeMarkerView: View {
    
    var timelineUseCase: TimelineUseCase
    
    fileprivate var body: some View {
        
        let timelines = timelineUseCase.state.timelines
        
        VStack(alignment: .leading, spacing: 0) {
            ForEach(timelines.indices, id: \.self) { index in
                HStack(alignment: .top, spacing: 0) {
                    
                    let isHour = Calendar.current.component(.minute, from: timelines[index].start) == 0
                    
                    Text(timelines[index].start.formattedTimelineTime())
                        .frame(width: 47, height: 14, alignment: .leading)
                        .font(.custom(AppFont.medium, size: 12))
                        .foregroundStyle(AppColor.gray3)
                        .opacity(isHour ? 1 : 0)
                        .offset(y: -7)
                    
                    Spacer().frame(width: 14, height: 39)
                    
                    Rectangle()
                        .frame(width: index % 2 == 0 ? 28 : 16, height: 1)
                        .foregroundStyle(AppColor.gray2)
                }
                
            }
            
            // 마지막 시간 표시
            HStack(alignment: .top, spacing: 0) {
                if Calendar.current.component(.minute, from: timelines.last!.end) == 0 {
                    Text(timelines.last!.end.formattedTimelineTime())
                        .frame(width: 47, height: 14, alignment: .leading)
                        .font(.custom(AppFont.medium, size: 12))
                        .foregroundStyle(AppColor.gray3)
                        .offset(y: -7)

                    Spacer().frame(width: 14)

                    Rectangle()
                        .frame(width: timelines.count % 2 == 0 ? 28 : 16, height: 1)
                        .foregroundStyle(AppColor.gray2)
                }
            }
            .frame(height: 0)
            .offset(y: 5)
        }
    }
}

// MARK: - TimelineContentView
fileprivate struct TimelineContentView: View {
    
    var timelineUseCase: TimelineUseCase
    
    fileprivate var body: some View {
        
        let timelines = timelineUseCase.state.timelines
        let groupedTimelines = timelineUseCase.groupedTimelines()
        
        if timelineUseCase.state.editTimeline {
            VStack(alignment: .leading, spacing:4) {
                ForEach(timelines.indices, id: \.self) { index in
                    Button(action: {
                    }, label: {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.timelineBlue)
                            .frame(
                                width: timelines[index].isAvailable ? nil : 4,
                                height: 35
                            )
                    })
                }
            }
        } else {
            VStack(alignment: .leading, spacing:0) {
                ForEach(groupedTimelines.indices, id: \.self) { index in
                    
                    let item = groupedTimelines[index]
                    let totalHeight = CGFloat(item.count * 35 + 4 * (item.count - 1))
                    
                    if item.isAvailable {
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.timelineBlue)
                                .frame(height: totalHeight)
                                .padding(.vertical, 2)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                if item.count >= 2 {
                                    Spacer().frame(height: 16)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("\(item.start.formattedTimelineTime()) - \(item.end.formattedTimelineTime())")
                                            .font(.custom(AppFont.medium, size: 12))
                                            .foregroundStyle(AppColor.gray4)
                                        
                                        Text("활용 가능 시간")
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 5)
                                            .background(Capsule().fill(AppColor.mainBlue))
                                            .font(.custom(AppFont.medium, size: 12))
                                            .foregroundColor(.white)
                                            
                                        
                                    }.padding(.leading, 20)
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Spacer()
                                    Text("\(timelineUseCase.formattedDuration(from: item.count))")
                                        .font(.custom(AppFont.semiBold, size: 20))
                                        .foregroundStyle(AppColor.gray4)
                                        .padding(.trailing, 20)
                                        .frame(height: 18)
                                }
                                Spacer().frame(height: item.count >= 2 ? 16 : 10)
                            }
                        }
                    } else {
                        HStack(alignment: .top, spacing: 15) {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(.timelineBlue)
                                .frame(width:4 ,height: totalHeight)
                                .padding(.vertical, 2)
                            
                            Text("일정 시간 (\(timelineUseCase.formattedDuration(from: item.count)))")
                                .font(.custom(AppFont.medium, size: 12))
                                .foregroundStyle(AppColor.gray3)
                                .frame(height: 14)
                                .padding(.top, 12)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TimelineView(timelineUseCase: TimelineUseCase(appSettingService: TestAppSettingsService(), dailyDataService: TestDailyDataService(), currentDate: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 0))!, isWeelky: false))
}

class TestAppSettingsService: AppSettingRepository {
    func updateAppSettings(_ appSetting: AppSetting) {
        print("hello")
    }
    
    func getAppSettings() -> AppSetting {
        
        let wakeupTime = Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 0))! // 7월 21일 오전 9시
        let bedTime = Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 2, minute: 0))! // 7월 22일 오전 2시
        
        return AppSetting(wakeupTime: wakeupTime, bedTime: bedTime, isLightMode: true, allowNotifications: true)
    }
    
    
}

class TestDailyDataService: DailyContentRepository {
    func createDailyContent(_ dailyContent: DailyContent) {
        print("hello")
    }
    
    func fetchDailyContents() -> Result<[DailyContent], SwiftDataError> {
        
        let timelines: [Timeline] = [
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 30))!,
                             isAvailable: true),  // 2024/07/21 09:00 - 09:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 10, minute: 0))!,
                             isAvailable: true), // 2024/07/21 09:30 - 10:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 10, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 10, minute: 30))!,
                             isAvailable: true),  // 2024/07/21 10:00 - 10:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 10, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 11, minute: 0))!,
                             isAvailable: true), // 2024/07/21 10:30 - 11:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 11, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 11, minute: 30))!,
                             isAvailable: true),  // 2024/07/21 11:00 - 11:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 11, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 12, minute: 0))!,
                             isAvailable: false), // 2024/07/21 11:30 - 12:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 12, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 12, minute: 30))!,
                             isAvailable: true),  // 2024/07/21 12:00 - 12:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 12, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 13, minute: 0))!,
                             isAvailable: true), // 2024/07/21 12:30 - 13:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 13, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 13, minute: 30))!,
                             isAvailable: true),  // 2024/07/21 13:00 - 13:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 13, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 14, minute: 0))!,
                             isAvailable: true), // 2024/07/21 13:30 - 14:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 14, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 14, minute: 30))!,
                             isAvailable: true),  // 2024/07/21 14:00 - 14:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 14, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 15, minute: 0))!,
                             isAvailable: true), // 2024/07/21 14:30 - 15:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 15, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 15, minute: 30))!,
                             isAvailable: true),  // 2024/07/21 15:00 - 15:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 15, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 16, minute: 0))!,
                             isAvailable: false), // 2024/07/21 15:30 - 16:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 16, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 16, minute: 30))!,
                             isAvailable: true),  // 2024/07/21 16:00 - 16:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 16, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 17, minute: 0))!,
                             isAvailable: false), // 2024/07/21 16:30 - 17:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 17, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 17, minute: 30))!,
                             isAvailable: true),  // 2024/07/21 17:00 - 17:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 17, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 18, minute: 0))!,
                             isAvailable: false), // 2024/07/21 17:30 - 18:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 18, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 18, minute: 30))!,
                             isAvailable: false),  // 2024/07/21 18:00 - 18:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 18, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 19, minute: 0))!,
                             isAvailable: false), // 2024/07/21 18:30 - 19:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 19, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 19, minute: 30))!,
                             isAvailable: false),  // 2024/07/21 19:00 - 19:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 19, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 20, minute: 0))!,
                             isAvailable: false), // 2024/07/21 19:30 - 20:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 20, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 20, minute: 30))!,
                             isAvailable: false),  // 2024/07/21 20:00 - 20:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 20, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 21, minute: 0))!,
                             isAvailable: false), // 2024/07/21 20:30 - 21:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 21, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 21, minute: 30))!,
                             isAvailable: false),  // 2024/07/21 21:00 - 21:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 21, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 22, minute: 0))!,
                             isAvailable: false), // 2024/07/21 21:30 - 22:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 22, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 22, minute: 30))!,
                             isAvailable: false),  // 2024/07/21 22:00 - 22:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 22, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 23, minute: 0))!,
                             isAvailable: false), // 2024/07/21 22:30 - 23:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 23, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 23, minute: 30))!,
                             isAvailable: true),  // 2024/07/21 23:00 - 23:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 23, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 0, minute: 0))!,
                             isAvailable: true), // 2024/07/21 23:30 - 00:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 0, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 0, minute: 30))!,
                             isAvailable: true),  // 2024/07/22 00:00 - 00:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 0, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 1, minute: 0))!,
                             isAvailable: true), // 2024/07/22 00:30 - 01:00
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 1, minute: 0))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 1, minute: 30))!,
                             isAvailable: true),  // 2024/07/22 01:00 - 01:30
                    Timeline(start: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 1, minute: 30))!,
                             end: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 2, minute: 0))!,
                             isAvailable: false)  // 2024/07/22 01:30 - 02:00
                ]
        
        let dailycontents = [
            DailyContent(date: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 0))!, timelines: timelines, totalAvailabilityTime: 8),
        ]
        
        do {
            return .success(dailycontents)
        } catch {
            return .failure(.fetchError)
        }
    }
    
    func updateDailyContent(dailyContent: DailyContent, timelines: [Timeline]) {
        print("hello")
    }
    
    func deleteDailyContent(_ dailyContent: DailyContent) {
        print("hello")
    }
}
