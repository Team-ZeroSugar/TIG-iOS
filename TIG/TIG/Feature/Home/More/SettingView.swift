//
//  SettingView.swift
//  TIG
//
//  Created by 이정동 on 7/28/24.
//

import SwiftUI

enum DisplayMode: Int, CaseIterable{
  case light = 0
  case dark = 1
  case system = 2
  
  var info: (id: Int, value: String) {
    switch self {
    case .light:
      return (self.rawValue, "라이트")
    case .dark:
      return (self.rawValue, "다크")
    case .system:
      return (self.rawValue, "시스템과 동일")
    }
  }
}

struct SettingView: View {
  @Environment(HomeViewModel.self) private var homeViewModel
  @State private var settingViewModel = SettingViewModel()
  
  @State private var wakeupTimeIndex: Int = UserDefaults.standard.integer(forKey: UserDefaultsKey.wakeupTimeIndex)
  @State private var bedTimeIndex: Int = UserDefaults.standard.integer(forKey: UserDefaultsKey.bedTimeIndex)
  @State private var isPresentWakeupTimePicker: Bool = false
  @State private var isPresentBedTimePicker: Bool = false
  
  var body: some View {
    List {
      Section("수면 시간 설정") {
        
          HStack {
            Text("기상 시간")
              .font(.custom(AppFont.medium, size: 16))
              .foregroundStyle(AppColor.gray04)
            Spacer()
            Button(action: {
              isPresentWakeupTimePicker = true
            }, label: {
              Text("\(wakeupTimeIndex.convertToKoreanTimeFormat())")
                .font(.custom(AppFont.medium, size: 16))
                .foregroundStyle(AppColor.blueMain)
            })
            .padding(6)
            .background(AppColor.gray00)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
          }
          .padding(3)
          
          
          HStack {
            Text("취침 시간")
              .font(.custom(AppFont.medium, size: 16))
              .foregroundStyle(AppColor.gray04)
            Spacer()
            Button(action: {
              isPresentBedTimePicker = true
            }, label: {
              Text("\(bedTimeIndex.convertToKoreanTimeFormat())")
                .font(.custom(AppFont.medium, size: 16))
                .foregroundStyle(AppColor.blueMain)
              
            })
            .padding(6)
            .background(AppColor.gray00)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
          }
          .padding(3)
          
          Button {
            settingViewModel.effect(.updateSleepTimeButtonTapped(
              wakeupTimeIndex,
              bedTimeIndex
            ))
            homeViewModel.effect(.updateSleepTimeButtonTapped)
          } label: {
            Text("저장")
          }
      }
      
      //            Section("화면 모드") {
      //                Picker("화면 모드", selection: $selectedMode) {
      //                    ForEach(DisplayMode.allCases, id: \.self) { item in
      //                        Text(item.info.value)
      //                            .font(.custom(AppFont.bold, size: 16))
      //                            .tag(item)
      //                    }
      //                }
      //                .font(.custom(AppFont.medium, size: 16))
      //                .foregroundStyle(AppColor.gray04)
      //                .padding(3)
      //
      //            }
      //
      //            Section {
      //                Toggle(isOn: .constant(true), label: {
      //                    Text("알림 허용")
      //                        .font(.custom(AppFont.medium, size: 16))
      //                        .foregroundStyle(AppColor.gray04)
      //                })
      //                .padding(3)
      //            } header: {
      //                Text("알림")
      //            } footer: {
      //                Text("활용 가능 시간을 알려드릴게요.")
      //            }
      
    }
    .navigationTitle("설정")
    .sheet(isPresented: $isPresentWakeupTimePicker, content: {
      CustomWheelPicker(selectedIndex: $wakeupTimeIndex)
        .presentationDetents([
          .fraction(0.4)
        ])
    })
    .sheet(isPresented: $isPresentBedTimePicker, content: {
      CustomWheelPicker(selectedIndex: $bedTimeIndex)
        .presentationDetents([
          .fraction(0.4)
        ])
    })
  }
  
  //    private func CustomDatePicker() -> some View {
  //        HStack {
  //            Picker("AMPM", selection: $isAm) {
  //                ForEach([true, false], id: \.self) { state in
  //                    Text("\(state ? "오전" : "오후")")
  //
  //                }
  //            }
  //            Picker("Hour", selection: $hour) {
  //                ForEach(
  //                    1..<Array(
  //                        repeating: hours,
  //                        count: 100
  //                    ).flatMap { $0 }.count + 1,
  //                    id: \.self)
  //                { hour in
  //                    Text("\(hours[(hour-1) % 12])")
  //                }
  //            }
  //            Picker("Minuts", selection: $minute) {
  //                ForEach(minutes, id: \.self) { minute in
  //                    Text("\(minute)")
  //                }
  //            }
  //        }
  //        .pickerStyle(.wheel)
  //        .padding()
  //    }
}


#Preview {
  SettingView()
    .environment(HomeViewModel())
}
