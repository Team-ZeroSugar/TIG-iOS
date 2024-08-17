//
//  AppColor.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import Foundation
import SwiftUI

struct AppColor {
  static let gray1 = Color(.gray01)
  static let gray2 = Color(.gray02)
  static let gray3 = Color(.gray03)
  static let gray4 = Color(.gray04)
  static let gray5 = Color(.gray05)
  static let darkWhite = Color(.darkWhite)
  static let darkOnboarding = Color(.darkOnboarding)
  static let blueMain = Color(.blueMain)
  static let blueTimeline = Color(.blueTimeline)
  static let timelineStroke = Color(.timelineStroke)
  static let background = Color(.background)
}

extension LinearGradient {
  static let main = Self(
    colors: [
      .gradientTop,
      .gradientMid,
      .gradientBot
    ],
    startPoint: .topTrailing,
    endPoint: .bottomLeading
  )
}
