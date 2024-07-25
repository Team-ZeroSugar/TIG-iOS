//
//  AnnounceView.swift
//  TIG
//
//  Created by Seo-Jooyoung on 7/23/24.
//

import SwiftUI

struct AnnounceView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 42) {
            VStack(spacing: 13) {
                Image("AvailableIcon")
                Text("오늘 일정을 설정해 보세요")
                    .font(.system(size: 20, weight: .semibold))
                Text("자유롭게 활용 가능한 시간을 알려줄게요")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.gray)
            }
            Button(action: {

            }, label: {
                Text("설정하기")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
            })
            .background(.blue)
            .clipShape(Capsule())
        }
    }
}

#Preview {
    AnnounceView()
}
