//
//  RepeatEditView.swift
//  TIG
//
//  Created by 신승재 on 8/7/24.
//

import SwiftUI

enum Day: Int, CaseIterable {
    case sun = 1
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    
    var value: String {
        switch self {
        case .sun:
            "일"
        case .mon:
            "월"
        case .tue:
            "화"
        case .wed:
            "수"
        case .thu:
            "목"
        case .fri:
            "금"
        case .sat:
            "토"
        }
    }
}

struct WeeklyRepeatView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(HomeViewModel.self) var homeViewModel
    
    var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            
            VStack {
                if !homeViewModel.state.weeklyRepeats[.sun]!.timelines.isEmpty {
                    Spacer().frame(height: 28)
                    
                    DaySelectView(homeViewModel: homeViewModel)
                        .padding(.horizontal, 33)
                }
                
                Spacer()
                
                TimelineView(selectedDay: homeViewModel.state.selectedDay)
                
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle(homeViewModel.state.isEditMode ? "반복 일정 편집" : "반복 일정 관리")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !homeViewModel.state.weeklyRepeats[.sun]!.timelines.isEmpty {
                    Button(action: {
                        homeViewModel.effect(.editTapped)
                    }, label: {
                        Text(homeViewModel.state.isEditMode ? "확인" : "편집")
                    })
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    homeViewModel.effect(.exitRepeatView)
                    dismiss()
                }, label: {
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                        
                        Spacer().frame(width: 3)
                        
                        Text("뒤로")
                    }
                }).offset(x: -7)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            homeViewModel.effect(.enterRepeatView)
        }
    }
}

// MARK: - (S)Day Select View
fileprivate struct DaySelectView: View {
    
    private var homeViewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }

    fileprivate var body: some View {
        HStack(spacing: 0) {
            ForEach(Day.allCases, id: \.self) { day in
                if day.rawValue != 1 {
                    Spacer()
                }
                Button(action: {
                    homeViewModel.effect(.dayChange(day))
                }, label: {
                    ZStack {
                        Circle().frame(width: 35, height: 35)
                            .foregroundColor(homeViewModel.state.selectedDay == day ? .blueMain : .clear)
                        
                        Text(day.value)
                            .font(.custom(
                                homeViewModel.state.selectedDay == day ? AppFont.semiBold : AppFont.medium, size: 14))
                            .foregroundColor(homeViewModel.state.selectedDay == day ? .darkWhite : .gray03)
                    }
                })
            }
        }.padding(.bottom, 10)
    }
}

#Preview {
    WeeklyRepeatView().environment(HomeViewModel())
}
