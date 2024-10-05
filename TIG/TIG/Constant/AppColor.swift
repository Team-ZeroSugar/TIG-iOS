//
//  AppColor.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import Foundation
import SwiftUI

struct AppColor {
  static let gray00 = Color(.gray00)
  static let gray01 = Color(.gray01)
  static let gray02 = Color(.gray02)
  static let gray03 = Color(.gray03)
  static let gray04 = Color(.gray04)
  static let gray05 = Color(.gray05)
    
  static let timerGray = Color(.timerGray)
  
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
      .linearGradientTop,
      .linearGradientMid,
      .linearGradientBot
    ],
    startPoint: .topTrailing,
    endPoint: .bottomLeading
  )
}
