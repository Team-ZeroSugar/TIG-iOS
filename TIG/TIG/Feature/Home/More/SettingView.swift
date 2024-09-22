//
//  SettingView.swift
//  TIG
//
//  Created by 이정동 on 7/28/24.
//

import SwiftUI

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
                .padding(4)
            })
            .padding(6)
            .background(AppColor.gray00)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .buttonStyle(.plain)
            .confirmationDialog(isPresented: $isPresentWakeupTimePicker) {
              CustomWheelPicker(selectedIndex: $wakeupTimeIndex)
                .background {
                  RoundedRectangle(cornerRadius: 10)
                    .fill(AppColor.blueMain.opacity(0.5))
                    .frame(width: 300, height: 40)
                }
            } actions: {
              SheetAction(title: "ok", role: .default) {
                
              }
              SheetAction(title: "cancel", role: .cancel)
            }

          }
          
          
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
                .padding(4)
            })
            .padding(6)
            .background(AppColor.gray00)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .buttonStyle(.plain)
          }
          
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
  }
  
}


#Preview {
  SettingView()
    .environment(HomeViewModel())
}
