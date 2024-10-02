//
//  TimerAnnounceView.swift
//  TIG
//
//  Created by Seo-Jooyoung on 7/26/24.
//

import SwiftUI

struct AnnounceView: View {
    @Environment(HomeViewModel.self) var homeViewModel
    private var isTimelineView: Bool
    
    init(isTimelineView: Bool = false) {
        self.isTimelineView = isTimelineView
    }

    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Image(.availableIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48)
                
                Spacer().frame(height: 24)
                
                MainTextView()
                
                Spacer().frame(height: 12)
                
                SubTextView()
            }
            Spacer().frame(height: 32)
            Button(action: {
              print("Tap")
                homeViewModel.effect(.settingButtonTapped)
                
                if !isTimelineView {
                    homeViewModel.effect(.tabChange(.timeline))
                }
                
            }, label: {
                Text("설정하기")
                    .font(.custom(AppFont.regular, size: 16))
                    .foregroundStyle(AppColor.darkWhite)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(AppColor.blueMain)
                    .clipShape(Capsule())
            })
        }
    }
    
    // MARK: - (F)MainTextView
    private func MainTextView() -> some View {
        Text(homeViewModel.state.isRepeatView ? "반복 일정을 설정해 보세요" : "오늘 일정을 설정해 보세요")
            .font(.custom(AppFont.semiBold, size: 20))
    }
    
    // MARK: - (F)SubTextView
    private func SubTextView() -> some View {
        if homeViewModel.state.isRepeatView {
            return Text("요일별로 고정된 일정을 반복할 수 있어요")
                .font(.custom(AppFont.regular, size: 16))
                .foregroundStyle(AppColor.gray04)
        } else {
            return Text(isTimelineView ? "자유롭게 활용 가능한 타임라인을 알려줄게요" : "자유롭게 활용 가능한 시간을 알려줄게요")
                .font(.custom(AppFont.regular, size: 16))
                .foregroundStyle(AppColor.gray04)
        }
    }
}

#Preview {
    AnnounceView().environment(HomeViewModel())
}
