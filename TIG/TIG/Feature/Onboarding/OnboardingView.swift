//
//  ContentView.swift
//  TIG
//
//  Created by 이정동 on 7/9/24.
//

import SwiftUI

struct OnboardingView: View {
  @State private var currentPage: Int = 1
  @State private var wakeupTimeIndex = 16
  @State private var bedTimeIndex = 46
  @State private var isDisable: Bool = false
  
  init() {
    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(resource: .blueMain)
    UIPageControl.appearance().pageIndicatorTintColor = UIColor.label.withAlphaComponent(0.2)
  }
  
  var body: some View {
    ZStack {
      AppColor.background.ignoresSafeArea()
      
      VStack {
        TabView(selection: $currentPage) {
          OnboardingFirstView()
            .tag(1)
          OnboardingSecondView()
            .tag(2)
          OnboardingThirdView()
            .tag(3)
          SleepTimeSettingView(selectedIndex: $wakeupTimeIndex, isWakeupMode: true)
            .tag(4)
          SleepTimeSettingView(selectedIndex: $bedTimeIndex, isWakeupMode: false)
            .tag(5)
        }
        .tabViewStyle(.page)
        
        Spacer().frame(height: 10)
        
        Button(action: {
          isDisable = true
          withAnimation {
            
            if currentPage == 5 { self.saveSleepTime() }
            else { currentPage += 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              isDisable = false
            }
          }
          
        }, label: {
          Text(currentPage == 5 ? "시작" : "계속")
            .foregroundStyle(.white)
            .font(.custom(AppFont.medium, size: 16))
            .padding(.vertical)
            .padding(.horizontal, 116)
            .background(RoundedRectangle(cornerRadius: 27.5)
              .foregroundStyle(AppColor.blueMain))
        })
        .disabled(isDisable)
        .padding(.bottom, 30)
        
      }
    }
  }
  
  private func saveSleepTime() {
    // TODO: DI 적용 필요
    UserDefaults.standard.set(false, forKey: UserDefaultsKey.isOnboarding)
    UserDefaults.standard.set(wakeupTimeIndex, forKey: UserDefaultsKey.wakeupTimeIndex)
    UserDefaults.standard.set(bedTimeIndex, forKey: UserDefaultsKey.bedTimeIndex)
  }
}

// TODO: OnboardingView들을 재사용 가능한 코드로 수정 필요

// MARK: - FirstView
fileprivate struct OnboardingFirstView: View {
  
  fileprivate var body: some View {
    VStack {
      Spacer().frame(height: 80)
      
      Image(.onboardingFirst)
        .resizable()
        .frame(
          width: UIScreen.main.bounds.width * 0.7,
          height: UIScreen.main.bounds.width * 0.7
        )
      
      Spacer().frame(height: 50)
      
      Text("어려운 시간 관리\n첫 단추를 잘 끼워볼까요?")
        .multilineTextAlignment(.center)
        .font(.custom(AppFont.bold, size: 24))
      
      Spacer()
    }
  }
}

// MARK: - SecondView
fileprivate struct OnboardingSecondView: View {
  
  fileprivate var body: some View {
    VStack {
      Spacer().frame(height: 80)
      
      Image(.onboardingSecond)
        .resizable()
        .frame(
          width: UIScreen.main.bounds.width * 0.7,
          height: UIScreen.main.bounds.width * 0.7
        )
      
      Spacer().frame(height: 50)
      
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

// MARK: - ThirdView
fileprivate struct OnboardingThirdView: View {
  
  fileprivate var body: some View {
    VStack {
      Spacer().frame(height: 80)
      
      Image(.onboardingThird)
        .resizable()
        .frame(
          width: UIScreen.main.bounds.width * 0.7,
          height: UIScreen.main.bounds.width * 0.7
        )
      
      Spacer().frame(height: 50)
      
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

// MARK: - SleepTimeSettingView
fileprivate struct SleepTimeSettingView: View {
  
  @Binding var selectedIndex: Int
  var isWakeupMode: Bool
  
  init(selectedIndex: Binding<Int>, isWakeupMode: Bool) {
    self._selectedIndex = selectedIndex
    self.isWakeupMode = isWakeupMode
  }
  
  fileprivate var body: some View {
    VStack(spacing: 0) {
      Spacer().frame(height: 80)
      
      Text(isWakeupMode ? "평소 몇 시에 일어나시나요?" : "평소 몇 시에 주무시나요?")
        .font(.custom(AppFont.bold, size: 28))
        .foregroundStyle(AppColor.gray05)
      
      Text("수면 시간을 제외한 활용 가능 시간을 알려드릴게요\n설정에서 언제든지 변경할 수 있습니다")
        .font(.custom(AppFont.regular, size: 14))
        .multilineTextAlignment(.center)
        .foregroundStyle(AppColor.gray04)
        .padding(.top, 12)
      
      Spacer()
        .frame(height: 30)
        
      Image(.circles)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .overlay {
          CustomWheelPicker(selectedIndex: $selectedIndex)
            .background {
              RoundedRectangle(cornerRadius: 10)
                .fill(AppColor.blueMain.opacity(0.5))
                .frame(
                  width: UIScreen.main.bounds.width * 0.4,
                  height: 40
                )
            }
        }
      
      Spacer()
    }
  }
}

#Preview {
  OnboardingView()
    
}


