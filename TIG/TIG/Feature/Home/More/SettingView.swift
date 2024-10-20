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
    
    @State private var wakeupTimeIndex: Int = UserDefaults.shared.integer(forKey: UserDefaultsKey.wakeupTimeIndex)
    @State private var bedTimeIndex: Int = UserDefaults.shared.integer(forKey: UserDefaultsKey.bedTimeIndex)
    
    @State private var wakeupPickerIndex: Int = 0
    @State private var bedPickerIndex: Int = 0
    
    @State private var isPresentWakeupTimePicker: Bool = false
    @State private var isPresentBedTimePicker: Bool = false
    
    var body: some View {
        List {
            Section("수면 시간 수정") {
                HStack {
                    
                    HStack {
                        Text("기상 시간")
                            .font(.custom(AppFont.medium, size: 16))
                            .foregroundStyle(AppColor.gray04)
                        Spacer()
                        Button(action: {
                            isPresentWakeupTimePicker = true
                            wakeupPickerIndex = wakeupTimeIndex
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
                            CustomWheelPicker(selectedIndex: $wakeupPickerIndex)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(AppColor.blueMain.opacity(0.5))
                                        .frame(width: 300, height: 40)
                                }
                        } actions: {
                            SheetAction(title: "확인", role: .default) {
                                wakeupTimeIndex = wakeupPickerIndex
                                
                                settingViewModel.effect(.updateSleepTimeButtonTapped(
                                    wakeupTimeIndex,
                                    bedTimeIndex
                                ))
                                homeViewModel.effect(.updateSleepTimeButtonTapped)
                            }
                            SheetAction(title: "취소", role: .cancel)
                        }
                        
                    }
                }
                
                HStack {
                    Text("취침 시간")
                        .font(.custom(AppFont.medium, size: 16))
                        .foregroundStyle(AppColor.gray04)
                    Spacer()
                    Button(action: {
                        isPresentBedTimePicker = true
                        bedPickerIndex = bedTimeIndex
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
                    .confirmationDialog(isPresented: $isPresentBedTimePicker) {
                        CustomWheelPicker(selectedIndex: $bedPickerIndex)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(AppColor.blueMain.opacity(0.5))
                                    .frame(width: 300, height: 40)
                            }
                    } actions: {
                        SheetAction(title: "확인", role: .default) {
                            bedTimeIndex = bedPickerIndex
                            
                            settingViewModel.effect(.updateSleepTimeButtonTapped(
                                wakeupTimeIndex,
                                bedTimeIndex
                            ))
                            homeViewModel.effect(.updateSleepTimeButtonTapped)
                        }
                        SheetAction(title: "취소", role: .cancel)
                    }
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
        .navigationTitle("수면 시간")
      
    }

    
}


#Preview {
    SettingView()
        .environment(HomeViewModel())
}
