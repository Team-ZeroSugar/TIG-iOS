//
//  RepeatEditView.swift
//  TIG
//
//  Created by 신승재 on 8/7/24.
//

import SwiftUI

enum Day: String, CaseIterable {
    case sun = "일"
    case mon = "월"
    case tue = "화"
    case wed = "수"
    case thu = "목"
    case fri = "금"
    case sat = "토"
}

struct RepeatEditView: View {
    
    @Environment(HomeViewModel.self) var homeViewModel
    
    var body: some View {
        VStack {
            Spacer().frame(height: 28)
            
            DaySelectView(homeViewModel: homeViewModel)
                .padding(.horizontal, 33)
            
            TimelineView(isRepeatView: true)
        }
        .navigationTitle("반복 일정 관리")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {}, label: {
                    Text("확인")
                })
            }
        })
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
            ForEach(Array(Day.allCases.enumerated()), id: \.element) { index, day in
                if index != 0 {
                    Spacer()
                }
                Button(action: {
                    homeViewModel.effect(.dayChange(day))
                }, label: {
                    ZStack {
                        Circle().frame(width: 35, height: 35)
                            .foregroundColor(homeViewModel.state.selectedDay == day ? .blueMain : .clear)
                        
                        Text(day.rawValue)
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
    RepeatEditView().environment(HomeViewModel())
}
