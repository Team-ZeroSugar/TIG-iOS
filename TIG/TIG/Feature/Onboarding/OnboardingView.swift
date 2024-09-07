//
//  ContentView.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import SwiftUI

struct OnboardingView: View {
  
  @State private var selectedTab: Int = 1
  
  init() {
    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(resource: .blueMain)
    UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
  }
  
  var body: some View {
    ZStack {
      AppColor.background.ignoresSafeArea()
      
      VStack {
        TabView(selection: $selectedTab) {
          OnboardingFirstView()
            .tag(1)
          
          OnboardingSecondView()
            .tag(2)
          
          OnboardingThirdView()
            .tag(3)
        }
        .tabViewStyle(.page)
        
        Spacer().frame(height: 50)
        
        Button(action: {
          withAnimation {
            if selectedTab < 5 {
              selectedTab += 1
            } else {
              print("시작")
            }
          }
          
        }, label: {
          Text(selectedTab == 5 ? "시작" : "계속")
            .foregroundStyle(.white)
            .font(.custom(AppFont.medium, size: 16))
            .padding(.vertical)
            .padding(.horizontal, 116)
            .background(RoundedRectangle(cornerRadius: 27.5))
        })
        .padding(.bottom, 30)
      }
    }
  }
}

fileprivate struct OnboardingFirstView: View {
  
  fileprivate var body: some View {
    VStack {
      Spacer().frame(height: 100)
      
      Image(.onboardingFirst)
        .resizable()
        .frame(width: 300, height: 300)
      
      Spacer().frame(height: 30)
      
      Text("어려운 시간 관리\n첫 단추를 잘 끼워볼까요?")
        .multilineTextAlignment(.center)
        .font(.custom(AppFont.bold, size: 24))
      
      Spacer()
    }
  }
}

fileprivate struct OnboardingSecondView: View {
  
  fileprivate var body: some View {
    VStack {
      Spacer().frame(height: 100)
      
      Image(.onboardingSecond)
        .resizable()
        .frame(width: 300, height: 300)
      
      Spacer().frame(height: 30)
      
      Text("활용 가능 시간은")
        .font(.custom(AppFont.bold, size: 24))
      Text("하루 중 일정이 있는 시간을 제외한\n자유롭게 활용할 수 있는 시간이에요!")
        .multilineTextAlignment(.center)
        .font(.custom(AppFont.regular, size: 16))
        .foregroundStyle(AppColor.gray03)
        .padding(.top, 10)
      
      Spacer()
    }
  }
}

fileprivate struct OnboardingThirdView: View {
  
  fileprivate var body: some View {
    VStack {
      Spacer().frame(height: 100)
      
      Image(.onboardingThird)
        .resizable()
        .frame(width: 300, height: 300)
      
      Spacer().frame(height: 30)
      
      Text("오늘의 남은 활용 가능 시간을\n인지할 수 있어요")
        .multilineTextAlignment(.center)
        .font(.custom(AppFont.bold, size: 24))
      Text("남은 시간에 대한 계획을 세워보세요")
        .font(.custom(AppFont.regular, size: 16))
        .foregroundStyle(AppColor.gray03)
        .padding(.top, 10)
      
      Spacer()
    }
  }
}

#Preview {
  OnboardingView()
}
