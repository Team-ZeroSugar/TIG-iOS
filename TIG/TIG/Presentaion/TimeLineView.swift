//
//  TimeLineView.swift
//  TIG
//
//  Created by 신승재 on 7/19/24.
//

import SwiftUI

struct TimelineView: View {
    
    @Bindable var timelineUseCase: TimelineUseCase
    
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
    @Bindable var timelineUseCase: TimelineUseCase
    
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
    
    @Bindable var timelineUseCase: TimelineUseCase

    fileprivate var body: some View {
        
        let filteredTimelines = timelineUseCase.filteredTimelines()
        let groupedTimelines = timelineUseCase.groupedTimelines()
        
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(filteredTimelines.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top, spacing: 0) {
                            
                            let isHour = Calendar.current.component(.minute, from: filteredTimelines[index].start) == 0
                            
                            Text(filteredTimelines[index].start.formattedTimelineTime())
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
                }
            }
            
            Spacer().frame(width: 18)
            
            if timelineUseCase.state.editTimeline {
                VStack(alignment: .leading, spacing:4) {
                    ForEach(filteredTimelines.indices, id: \.self) { index in
                        Button(action: {
                        }, label: {
                            if filteredTimelines[index].isAvailable {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.timelineBlue)
                                    .frame(height: 35)
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.timelineBlue)
                                    .frame(width: 4,height: 35)
                                Spacer()
                            }
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
        
        // 마지막 시간 표시
        HStack(alignment: .top, spacing: 0) {
            if Calendar.current.component(.minute, from: filteredTimelines.last!.end) == 0 {
                Text(filteredTimelines.last!.end.formattedTimelineTime())
                    .frame(width: 47, height: 14, alignment: .leading)
                    .font(.custom(AppFont.medium, size: 12))
                    .foregroundStyle(AppColor.gray3)
                    .offset(y: -7)
                
                Spacer().frame(width: 14)
                
                Rectangle()
                    .frame(width: filteredTimelines.count % 2 == 0 ? 28 : 16, height: 1)
                    .foregroundStyle(AppColor.gray2)
                
                Spacer()
            }
        }.offset(y: -10)
    }
}

#Preview {
    TimelineView(timelineUseCase: TimelineUseCase())
}
