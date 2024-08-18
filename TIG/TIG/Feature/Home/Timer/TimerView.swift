//
//  TimerView.swift
//  TIG
//
//  Created by Seo-Jooyoung on 7/26/24.
//

import SwiftUI

let timer = Timer
    .publish(every: 60, on: .main, in: .common)
    .autoconnect()

struct TimerView: View {
//    // homeViewModel에 저장된 DailyContent를 가지고 계산 필요
    @Environment(HomeViewModel.self) var homeViewModel
    
    @State var counter: Int = 0
    // 타이머가 끝나는 시간
    var countTo: Int = 18000
    
    var body: some View {
        VStack {
            TimerHeaderView()
            Spacer().frame(height: 52)
            TimerBodyView(counter: counter, countTo: countTo)
            Spacer()
        
        }.onReceive(timer) { time in
            if (self.counter < self.countTo) {
                self.counter += 60
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 44)
    }
}

// MARK: - TimerHeaderView

fileprivate struct TimerHeaderView: View {
    @Bindable private var homeViewModel: HomeViewModel

    fileprivate var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 79)
                .foregroundStyle(AppColor.gray01)
            HStack(spacing: 20) {
                Image(homeViewModel.isCurrentTimeAvailable() ? "AvailableIcon" : "UnavailableIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36)
                VStack(alignment: .leading, spacing: 5) {
                    Text("오전 11시 - 오후 2시")
                        .font(.custom(AppFont.semiBold, size: 12))
                        .foregroundStyle(AppColor.gray03)
                    HStack(spacing: 0) {
                        Text("지금은 ")
                        Text(homeViewModel.isCurrentTimeAvailable() ? "활용할 수 있는 시간" : "활용할 수 없는 시간")
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
    @State var counter: Int
    // 타이머가 끝나는 시간
    var countTo: Int
    
    fileprivate var body: some View {
        VStack(spacing: 48) {
            HStack {
                Text("오늘의 활용 가능 시간")
                    .font(.custom(AppFont.semiBold, size: 18))
                Spacer()
            }
            
            ZStack {
                TimerTrack()
                
                TimerProgressBar(counter: counter, countTo: countTo)
                
                VStack(spacing: 4) {
                    Text("남은 활용 가능 시간")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(AppColor.darkWhite)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 11)
                        .background(AppColor.blueMain)
                        .clipShape(Capsule())
                        .padding(.bottom, 6)
                    
                    Clock(counter: counter, countTo: countTo)
                    
                    Text("/ 8시간 30분")
                        .font(.custom(AppFont.medium, size: 13))
                }
            }
            .padding(.horizontal, 16)
        }
    }
}


// 배경에 고정된 원
fileprivate struct TimerTrack: View {
    fileprivate var body: some View {
        Circle()
            .fill(Color.clear)
            .frame(height: 318)
            .overlay(
                Circle().stroke(AppColor.darkWhite, lineWidth: 16)
            )
    }
}

// 움직이는 원
fileprivate struct TimerProgressBar: View {
    var counter: Int
    var countTo: Int
    
    fileprivate var body: some View {
        // 진행 상태를 나타내는 원
        Circle()
            .trim(from: progress(), to: 1)
            .stroke(
                style: StrokeStyle(
                    lineWidth: 24,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .rotationEffect(.degrees(-90))
            .foregroundStyle(LinearGradient.main)
            .animation(
                Animation.easeInOut(duration: 0.2),
                value: counter
            )
            .frame(height: 318)
    }
    func progress() -> CGFloat {
        return (CGFloat(counter) / CGFloat(countTo))
    }
}

fileprivate struct Clock: View {
    var counter: Int
    var countTo: Int
    
    fileprivate var body: some View {
        VStack {
            Text(counterToMinutes())
                .font(.custom(AppFont.semiBold, size: 36))
        }
    }
    
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let hours = currentTime / 3600
        let minutes = (currentTime % 3600) / 60
        
        return String(format: "%01d시간 %01d분", hours, minutes)
    }
}

#Preview {
    TimerView()
}
