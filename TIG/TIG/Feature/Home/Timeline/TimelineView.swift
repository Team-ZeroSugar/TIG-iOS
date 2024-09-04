//
//  TimeLineView.swift
//  TIG
//
//  Created by 신승재 on 7/19/24.
//

import SwiftUI

struct TimelineView: View {
    
    @Environment(HomeViewModel.self) var homeViewModel
    private var selectedDay: Day?
    
    init(selectedDay: Day? = nil) {
        self.selectedDay = selectedDay
    }
    
    var body: some View {
        
        if homeViewModel.state.dailyContent.timelines.count == 0 {
            
            AnnounceView()
            
        } else {
            if selectedDay == nil {
                Spacer().frame(height: 47)
                
                TimelineHeaderView(homeViewModel: homeViewModel)
                    .padding(.horizontal, 20)
            }
            
            ScrollView {
                VStack {
                    Spacer().frame(height: 20)
                    
                    TimelineBodyView(homeViewModel: homeViewModel, selectedDay: selectedDay)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}


// MARK: - Header View
fileprivate struct TimelineHeaderView: View {
    
    @Bindable private var homeViewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    fileprivate var body: some View {
        HStack {
            Text(homeViewModel.state.isEditMode ? "오늘 일정 시간을 탭해서 지워주세요" : "지금은 활용 가능 시간이에요")
                .font(.custom(AppFont.semiBold, size: 18))
                .foregroundStyle(AppColor.gray05)
            
            Spacer()
            
            Button(action: {
                homeViewModel.effect(.editTapped)
            }, label: {
                Text(homeViewModel.state.isEditMode ? "완료" : "편집")
                    .font(.custom(AppFont.medium, size: 16))
                    .foregroundStyle(AppColor.blueMain)
            })
        }
    }
}

// MARK: - Body View
fileprivate struct TimelineBodyView: View {
    
    @Bindable private var homeViewModel: HomeViewModel
    private var selectedDay: Day?
    
    init(homeViewModel: HomeViewModel, selectedDay: Day? = nil) {
        self.homeViewModel = homeViewModel
        self.selectedDay = selectedDay
    }

    fileprivate var body: some View {
        
        HStack(spacing: 0) {

            TimeMarkerView(homeViewModel: homeViewModel, selectedDay: selectedDay)
            
            Spacer().frame(width: 18)
            
            TimelineContentView(homeViewModel: homeViewModel, selectedDay: selectedDay)
            
        }
        .padding(.bottom, 50)
    }
}

// MARK: - TimeMarkerView
fileprivate struct TimeMarkerView: View {
    
    @Bindable private var homeViewModel: HomeViewModel
    private var selectedDay: Day?
    
    init(homeViewModel: HomeViewModel, selectedDay: Day? = nil) {
        self.homeViewModel = homeViewModel
        self.selectedDay = selectedDay
    }
    
    fileprivate var body: some View {
        
        let timelines = selectedDay == nil ? homeViewModel.state.dailyContent.timelines : TestData.timelines
        
        VStack(alignment: .leading, spacing: 0) {
            ForEach(timelines.indices, id: \.self) { index in
                HStack(alignment: .top, spacing: 0) {
                    
                  let isHour = timelines[index].start.minute! == 0
                    
                  Text(timelines[index].start.formattedTimelineTime()!)
                        .frame(width: 47, height: 14, alignment: .leading)
                        .font(.custom(AppFont.medium, size: 12))
                        .foregroundStyle(AppColor.gray03)
                        .opacity(isHour ? 1 : 0)
                        .offset(y: -7)
                    
                    Spacer().frame(width: 14, height: 39)
                    
                    Rectangle()
                        .frame(width: index % 2 == 0 ? 28 : 16, height: 1)
                        .foregroundStyle(AppColor.gray02)
                }
                
            }
            
            // 마지막 시간 표시
            HStack(alignment: .top, spacing: 0) {
              
              // TODO: (Monfi) 임의 수정 (확인해보고 수정)
              if timelines.last!.end.minute! == 0 {
                
                // TODO: (Monfi) 임의 수정 (확인해보고 수정)
                    Text(timelines.last!.end.formattedTimelineTime()!)
                        .frame(width: 47, height: 14, alignment: .leading)
                        .font(.custom(AppFont.medium, size: 12))
                        .foregroundStyle(AppColor.gray03)
                        .offset(y: -7)

                    Spacer().frame(width: 14)

                    Rectangle()
                        .frame(width: timelines.count % 2 == 0 ? 28 : 16, height: 1)
                        .foregroundStyle(AppColor.gray02)
                }
            }
            .frame(height: 0)
            .offset(y: 5)
        }
    }
}

// MARK: - TimelineContentView
fileprivate struct TimelineContentView: View {
    
    @Bindable private var homeViewModel: HomeViewModel
    private var selectedDay: Day?
    
    init(homeViewModel: HomeViewModel, selectedDay: Day? = nil) {
        self.homeViewModel = homeViewModel
        self.selectedDay = selectedDay
    }
    
    fileprivate var body: some View {
        
        let timelines = selectedDay == nil ? homeViewModel.state.dailyContent.timelines : TestData.timelines
        
        let groupedTimelines = homeViewModel.groupedTimelines(timelines: timelines)
        
        if homeViewModel.state.isEditMode {
            VStack(alignment: .leading, spacing:4) {
                ForEach(timelines.indices, id: \.self) { index in
                    Button(action: {
                        homeViewModel.effect(.timeSlotTapped(index))
                    }, label: {
                        RoundedRectangle(cornerRadius: 8)
                        .fill(timelines[index].isAvailable ? AppColor.blueTimeline : Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                  .stroke(AppColor.timelineStroke, lineWidth: 2)
                                    .opacity(timelines[index].isAvailable ? 0 : 1)
                            )
                            .frame(height: 35)
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
                            .foregroundStyle(AppColor.blueTimeline)
                                .frame(height: totalHeight)
                                .padding(.vertical, 2)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                VStack(alignment: .leading, spacing: 0) {
                                    
                                    if item.count >= 2 {
                                        Spacer().frame(height: 16)
                                        
                                        Text("\(item.start.formattedTimelineTime()!) - \(item.end.formattedTimelineTime()!)")
                                            .font(.custom(AppFont.medium, size: 12))
                                            .foregroundStyle(AppColor.gray04)
                                        
                                        Spacer().frame(height: 8)
                                    }
                                    
                                    HStack(alignment: .top) {
                                        if item.count >= 2 {
                                            Text("활용 가능 시간")
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 5)
                                                .background(Capsule().fill(AppColor.blueMain))
                                                .font(.custom(AppFont.medium, size: 12))
                                                .foregroundColor(.darkWhite)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack {
                                            
                                            Spacer()
                                            
                                            Text("\(item.count.formattedDuration())")
                                                .font(.custom(AppFont.semiBold, size: 20))
                                                .foregroundStyle(AppColor.gray04)
                                                .padding(.trailing, 20)
                                                .frame(height: 18)
                                            
                                            Spacer().frame(height: item.count >= 2 ? 16 : 10)
                                            
                                        }
                                    }
                                    
                                }.padding(.leading, 20)
                            }
                        }
                    } else {
                        HStack(alignment: .top, spacing: 15) {
                            RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(AppColor.blueMain)
                                .frame(width:4 ,height: totalHeight)
                                .padding(.vertical, 2)
                            
                            Text("일정 시간 (\(item.count.formattedDuration()))")
                                .font(.custom(AppFont.bold, size: 12))
                                .foregroundStyle(AppColor.gray04)
                                .frame(height: 14)
                                .padding(.top, 12)
                            
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TimelineView().environment(HomeViewModel())
}
