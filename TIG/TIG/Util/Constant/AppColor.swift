//
//  AppColor.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import Foundation
import SwiftUI

struct AppColor {
    static let gray0 = Color(.gray0)
    static let gray1 = Color(.gray1)
    static let gray2 = Color(.gray2)
    static let gray3 = Color(.gray3)
    static let gray4 = Color(.gray4)
    static let gray5 = Color(.gray5)
    static let white = Color(.mainWhite)
    static let mainBlue = Color(.mainBlue)
    static let timelineBlue = Color(.timelineBlue)
    static let timelineStroke = Color(.timelineStroke)
    static let bgLight = Color(.bgLight)
}

extension LinearGradient {
    static let main = Self(
        colors: [
            .linearGradientTop,
            .linearGradientMid,
            .linearGradientBot
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
