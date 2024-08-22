//
//  TimerAnnounceView.swift
//  TIG
//
//  Created by Seo-Jooyoung on 7/26/24.
//

import SwiftUI

struct AnnounceView: View {
    @Environment(HomeViewModel.self) var homeViewModel

    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Image(.availableIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48)
                Spacer().frame(height: 24)
                Text("오늘 일정을 설정해 보세요")
                    .font(.custom(AppFont.semiBold, size: 20))
                Spacer().frame(height: 12)
                Text(homeViewModel.state.activeTab == .time ? "자유롭게 활용 가능한 시간을 알려줄게요" : "자유롭게 활용 가능한 타임라인을 알려줄게요")
                    .font(.custom(AppFont.regular, size: 16))
                    .foregroundStyle(AppColor.gray04)
            }
            Spacer().frame(height: 32)
            Button(action: {
                
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
}

#Preview {
    AnnounceView()
}
