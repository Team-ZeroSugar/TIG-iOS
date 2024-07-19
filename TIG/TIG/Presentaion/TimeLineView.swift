//
//  TimeLineView.swift
//  TIG
//
//  Created by 신승재 on 7/19/24.
//

import SwiftUI

struct TimelineView: View {
    
    @State var isEditing: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer().frame(height: 47)
                
                TimelineHeaderView(isEditing: $isEditing)
                
                Spacer().frame(height: 51)
                
                TimelineBodyView(isEditing: $isEditing)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Header View
fileprivate struct TimelineHeaderView: View {
    @Binding var isEditing: Bool
    
    fileprivate var body: some View {
        HStack {
            Text(isEditing ? "오늘 일정 시간을 탭해서 지워주세요" : "지금은 활용 가능 시간이에요")
                .font(.custom(AppFont.semiBold, size: 18))
                .foregroundStyle(AppColor.gray5)
            
            Spacer()
            
            Button(action: {
                isEditing.toggle()
            }, label: {
                Text(isEditing ? "완료" : "편집")
                    .font(.custom(AppFont.medium, size: 16))
                    .foregroundStyle(AppColor.mainBlue)
            })
        }
    }
}

// MARK: - Body View
fileprivate struct TimelineBodyView: View {
    
    @Binding var isEditing: Bool
    
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(18..<54) { index in
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top, spacing: 0) {
                        Text(timeString(for: index))
                            .frame(width: 47, height: 14, alignment: .leading)
                            .font(.custom(AppFont.medium, size: 12))
                            .foregroundStyle(AppColor.gray3)
                            .opacity(index % 2 == 0 ? 1 : 0)
                            .offset(y: -7)
                        
                        Spacer().frame(width: 14)
                        
                        Rectangle()
                            .frame(width: index % 2 == 0 ? 28 : 16, height: 1)
                            .foregroundStyle(AppColor.gray2)
                            
                        Spacer().frame(width: index % 2 == 0 ? 7 : 19)
                        
                        if isEditing {
                            VStack {
                                Spacer().frame(height: 2)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(height: 35)
                                    .foregroundStyle(AppColor.timelineBlue)
                                
                                Spacer().frame(height: 2)
                            }
                        } else {
                            Rectangle()
                                .frame(width: 4, height: 39)
                                .foregroundStyle(AppColor.timelineBlue)
                            
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

extension TimelineBodyView {
    func timeString(for index: Int) -> String {
        let hour = index / 2 % 24
        let period = hour < 12 ? "오전" : "오후"
        let displayHour = hour % 12 == 0 ? 12 : hour % 12
        return "\(period) \(displayHour)시"
    }
}

#Preview {
    TimelineView()
}

struct DailyContent {
    var date: Date
    var timeline: [Timeline]
    var totalAvailableTime: Int
}

struct Timeline {
    var startTime: Date
    var endTime: Date
    var isAvailableTime: Bool
}
