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
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(18..<54) { index in
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top, spacing: 0) {
                            Text(timelineUseCase.timeString(for: index))
                                .frame(width: 47, height: 14, alignment: .leading)
                                .font(.custom(AppFont.medium, size: 12))
                                .foregroundStyle(AppColor.gray3)
                                .opacity(index % 2 == 0 ? 1 : 0)
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
                    ForEach(18..<54) { index in
                        Button(action: {
                            
                        }, label: {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.timelineBlue)
                                .frame(height: 35)
                        })
                    }
                }
            } else {
                VStack(alignment: .leading, spacing:0) {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.timelineStroke)
                        .frame(width: 4)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    TimelineView(timelineUseCase: TimelineUseCase())
}
