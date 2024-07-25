//
//  MainTimeView.swift
//  TIG
//
//  Created by Seo-Jooyoung on 7/21/24.
//

import SwiftUI

struct MainTimeView: View {
    var body: some View {
        VStack {
            Spacer()
            TimerView()
            Spacer()
        }
        .background(AppColor.bgLight)
    }
}

#Preview {
    MainTimeView()
}
