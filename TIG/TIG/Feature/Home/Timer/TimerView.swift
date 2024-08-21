//
//  TimerView.swift
//  TIG
//
//  Created by Seo-Jooyoung on 7/26/24.
//

import SwiftUI

struct TimerView: View {
//    // homeViewModel에 저장된 DailyContent를 가지고 계산 필요
    @Environment(HomeViewModel.self) var homeViewModel
    
    var body: some View {
        VStack {
            TimerHeaderView(homeViewModel: homeViewModel)
            Spacer().frame(height: 52)
            TimerBodyView(homeViewModel: homeViewModel)
            Spacer()
        
        }
        .padding(.horizontal, 20)
        .padding(.top, 44)
    }
}

// MARK: - TimerHeaderView

fileprivate struct TimerHeaderView: View {
    @Bindable private var homeViewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }

    fileprivate var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 79)
                .foregroundStyle(AppColor.gray01)
            HStack(spacing: 20) {
                Image(homeViewModel.currentTimeline()?.isAvailable == true ? "AvailableIcon" : "UnavailableIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36)
                VStack(alignment: .leading, spacing: 5) {
                    if let timeline = homeViewModel.currentTimeline() {
                        // Safely unwrap and format the start and end times
                        let startTime = timeline.start.formattedTimelineTime() ?? ""
                        let endTime = timeline.end.formattedTimelineTime() ?? ""
                        Text("\(startTime) - \( endTime)")
                            .font(.custom(AppFont.semiBold, size: 12))
                            .foregroundStyle(AppColor.gray03)
                    } else {
                        Text("타임라인 정보 없음")
                            .font(.custom(AppFont.semiBold, size: 12))
                            .foregroundStyle(AppColor.gray03)
                    }
                        
                    HStack(spacing: 0) {
                        Text("지금은 ")
                        Text(homeViewModel.currentTimeline()?.isAvailable == true ? "활용할 수 있는 시간" : "활용할 수 없는 시간")
                            .font(.custom(AppFont.bold, size: 16))
                            .foregroundStyle(AppColor.blueMain)
                        Text("이에요")
                    }
                    .font(.custom(AppFont.semiBold, size: 16))
                }
                Spacer()
            }
            .padding(.leading, 23)
            
        }
    }
}

// MARK: - TimerBodyView

fileprivate struct TimerBodyView: View {
    @Bindable private var homeViewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 48) {
            HStack {
                Text("오늘의 활용 가능 시간")
                    .font(.custom(AppFont.semiBold, size: 18))
                Spacer()
            }
            
            ZStack {
                TimerTrack()
                
                TimerProgressBar(progress: homeViewModel.progress())
                
                VStack(spacing: 4) {
                    Text("남은 활용 가능 시간")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(AppColor.darkWhite)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 11)
                        .background(AppColor.blueMain)
                        .clipShape(Capsule())
                        .padding(.bottom, 6)
                    
                    Text(homeViewModel.remainingTime())
                        .font(.custom(AppFont.semiBold, size: 36))
                    Text("/ \(homeViewModel.getTotalAvailableTime())")
                        .font(.custom(AppFont.medium, size: 13))
                }
            }
//            .padding(.horizontal, 16)
        }
    }
}


// 배경에 고정된 원
fileprivate struct TimerTrack: View {
    fileprivate var body: some View {
        Circle()
            .fill(Color.clear)
            .overlay(
                Circle().stroke(AppColor.darkWhite, lineWidth: 12)
            )
            .padding(.horizontal, 42)
        
    }
}

// 움직이는 원
fileprivate struct TimerProgressBar: View {
    var progress: CGFloat
    
    fileprivate var body: some View {
        // 진행 상태를 나타내는 원
        Circle()
            .trim(from: progress, to: 1)
            .stroke(
                style: StrokeStyle(
                    lineWidth: 16,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .rotationEffect(.degrees(-90))
            .foregroundStyle(LinearGradient.main)
            .animation(
                Animation.easeInOut(duration: 0.2),
                value: progress
            )
            .padding(.horizontal, 42)
    }
}

#Preview {
    TimerView()
}
