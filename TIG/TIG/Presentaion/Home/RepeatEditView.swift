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
            TopNavigationView()
                .padding(EdgeInsets(top: 11,
                                    leading: 8,
                                    bottom: 11,
                                    trailing: 20))
            
            Spacer().frame(height: 28)
            
            DaySelectView(homeViewModel: homeViewModel)
                .padding(.horizontal, 33)
            
            TimelineView(isRepeatView: true)
        }
    }
}

// MARK: - (S)Top Navigation View
fileprivate struct TopNavigationView: View {
    fileprivate var body: some View {
        HStack {
            Button(action: {
            }, label: {
                HStack(spacing: 3) {
                    Image(systemName: "chevron.left")
                        .font(.custom(AppFont.semiBold, size: 16))
                        .foregroundColor(.mainBlue)
                    
                    Text("뒤로")
                        .font(.custom(AppFont.medium, size: 16))
                        .foregroundColor(.mainBlue)
                }
            })
            
            Spacer()
            
            Text("반복 일정 편집")
                .font(.custom(AppFont.semiBold, size: 17))
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                Spacer().frame(width: 6)
                
                Text("완료")
                    .font(.custom(AppFont.semiBold, size: 16))
                    .foregroundColor(.mainBlue)
            })
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
                
                Button(action: {
                    homeViewModel.effect(.dayChange(day))
                }, label: {
                    ZStack {
                        Circle().frame(width: 35, height: 35)
                            .foregroundColor(homeViewModel.state.selectedDay == day ? .mainBlue : .clear)
                        
                        Text(day.rawValue)
                            .font(.custom(
                                homeViewModel.state.selectedDay == day ? AppFont.semiBold : AppFont.medium, size: 14))
                            .foregroundColor(homeViewModel.state.selectedDay == day ? .white : .gray4)
                    }
                })
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    RepeatEditView().environment(HomeViewModel())
}
