//
//  SettingView.swift
//  TIG
//
//  Created by 이정동 on 7/28/24.
//

import SwiftUI

enum DisplayMode {
    case auto, light, dark
}

struct SettingView: View {
    @State private var isAm: Bool = true
    @State private var hour: Int = 12 * 50
    @State private var minute: Int = 0
    @State private var isSheet: Bool = false
    @State private var selectedMode: DisplayMode = .auto

    let hours = [1,2,3,4,5,6,7,8,9,10,11,12]
    let minutes = [0, 30]

    var body: some View {
        List {
            Section("기상/취침 시간 설정") {

                    HStack {
                        Text("기상 시간")
                            .font(.custom(AppFont.medium, size: 16))
                            .foregroundStyle(AppColor.gray04)
                        Spacer()
                        Button(action: {
                            isSheet = true
                        }, label: {
                            Text("\(isAm ? "오전" : "오후") \(hours[(hour-1) % 12]) : \(minute.minutesFormat)")
                                .font(.custom(AppFont.regular, size: 17))
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
                            isSheet = true
                        }, label: {
                            Text("\(isAm ? "오전" : "오후") \(hours[(hour-1) % 12]) : \(minute.minutesFormat)")
                                .font(.custom(AppFont.regular, size: 17))
                                .foregroundStyle(AppColor.blueMain)

                        })
                        .padding(6)
                        .background(AppColor.gray00)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    .padding(3)



            }

            Section("화면 모드") {
//                Toggle(isOn: .constant(true), label: {
//                    Text("다크 모드")
//                })
//                .padding(3)
                ModeButton(selectedMode: $selectedMode, mode: .auto, title: "자동")
                
                ModeButton(selectedMode: $selectedMode, mode: .light, title: "라이트 모드")

                ModeButton(selectedMode: $selectedMode, mode: .dark, title: "다크 모드")
            }

            Section {
                Toggle(isOn: .constant(true), label: {
                    Text("알림 허용")
                })
                .padding(3)
            } header: {
                Text("알림")
            } footer: {
                Text("활용 가능 시간을 알려드릴게요.")
            }

        }
        .navigationTitle("설정")
        .sheet(isPresented: $isSheet, content: {
            CustomDatePicker()
                .presentationDetents([
                    .fraction(0.4)
                ])
        })
    }

    private func CustomDatePicker() -> some View {
        HStack {
            Picker("AMPM", selection: $isAm) {
                ForEach([true, false], id: \.self) { state in
                    Text("\(state ? "오전" : "오후")")

                }
            }
            Picker("Hour", selection: $hour) {
                ForEach(
                    1..<Array(
                        repeating: hours,
                        count: 100
                    ).flatMap { $0 }.count + 1,
                    id: \.self)
                { hour in
                    Text("\(hours[(hour-1) % 12])")
                }
            }
            Picker("Minuts", selection: $minute) {
                ForEach(minutes, id: \.self) { minute in
                    Text("\(minute)")
                }
            }
        }
        .pickerStyle(.wheel)
        .padding()

    }
}

struct ModeButton: View {
    @Binding var selectedMode: DisplayMode
    let mode: DisplayMode
    let title: String
    
    var body: some View {
        Button(action: {
            selectedMode = mode
        }, label: {
            HStack {
                Text(title)
                    .font(.custom(AppFont.medium, size: 16))
                    .foregroundStyle(AppColor.gray04)
                Spacer()
                if selectedMode == mode {
                    Image(systemName: "checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18)
                        .foregroundStyle(AppColor.blueMain)
                }
            }
            .padding(6)
        })
        .padding(.vertical, 3)
    }
}



#Preview {
    SettingView()
}
