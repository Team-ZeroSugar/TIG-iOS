//
//  TimerAnnounceView.swift
//  TIG
//
//  Created by Seo-Jooyoung on 7/26/24.
//

import SwiftUI

struct TimerAnnounceView: View {
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Image("AvailableIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48)
                Spacer().frame(height: 27)
                Text("오늘 일정을 설정해 보세요")
                    .font(.custom(AppFont.semiBold, size: 20))
                Spacer().frame(height: 13)
                Text("자유롭게 활용 가능한 시간을 알려줄게요")
                    .font(.custom(AppFont.regular, size: 16))
                    .foregroundStyle(AppColor.gray4)
            }
            Spacer().frame(height: 42)
            Button(action: {
                
            }, label: {
                Text("설정하기")
                    .font(.custom(AppFont.regular, size: 16))
                    .foregroundStyle(AppColor.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(AppColor.mainBlue)
                    .clipShape(Capsule())
            })
        }
    }
}

#Preview {
    TimerAnnounceView()
}
