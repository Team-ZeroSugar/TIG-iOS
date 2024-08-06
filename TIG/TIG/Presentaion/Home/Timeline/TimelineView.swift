//
//  TimeLineView.swift
//  TIG
//
//  Created by 신승재 on 7/19/24.
//

import SwiftUI

struct TimelineView: View {
    
    @Environment(HomeViewModel.self) var homeViewModel
    
    var body: some View {
        
        Spacer().frame(height: 47)
        
        TimelineHeaderView(homeViewModel: homeViewModel)
            .padding(.horizontal, 20)
        
        ScrollView {
            VStack {
                Spacer().frame(height: 51)
                
                TimelineBodyView(homeViewModel: homeViewModel)
            }
            .padding(.horizontal, 20)
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
                .foregroundStyle(AppColor.gray5)
            
            Spacer()
            
            Button(action: {
                homeViewModel.effect(.editTapped)
            }, label: {
                Text(homeViewModel.state.isEditMode ? "완료" : "편집")
                    .font(.custom(AppFont.medium, size: 16))
                    .foregroundStyle(AppColor.mainBlue)
            })
        }
    }
}

// MARK: - Body View
fileprivate struct TimelineBodyView: View {
    
    @Bindable private var homeViewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }

    fileprivate var body: some View {
        
        HStack(spacing: 0) {

            TimeMarkerView(homeViewModel: homeViewModel)
            
            Spacer().frame(width: 18)
            
            TimelineContentView(homeViewModel: homeViewModel)
            
        }
        .padding(.bottom, 50)
    }
}

// MARK: - TimeMarkerView
fileprivate struct TimeMarkerView: View {
    
    @Bindable private var homeViewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    fileprivate var body: some View {
        
        let timelines = homeViewModel.state.timelines
        
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
    
    @Bindable private var homeViewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    fileprivate var body: some View {
        
        let timelines = homeViewModel.state.timelines
        let groupedTimelines = homeViewModel.groupedTimelines()
        
        if homeViewModel.state.isEditMode {
            VStack(alignment: .leading, spacing:4) {
                ForEach(timelines.indices, id: \.self) { index in
                    Button(action: {
                        homeViewModel.effect(.timeSlotTapped(index))
                    }, label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(timelines[index].isAvailable ? .timelineBlue : Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.timelineBlue, lineWidth: 2)
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
                                    Text("\(homeViewModel.formattedDuration(from: item.count))")
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
                            
                            Text("일정 시간 (\(homeViewModel.formattedDuration(from: item.count)))")
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
    TimelineView().environment(HomeViewModel())
}
