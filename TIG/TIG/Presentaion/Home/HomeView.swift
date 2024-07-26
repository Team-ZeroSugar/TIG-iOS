//
//  HomeView.swift
//  TIG
//
//  Created by 이정동 on 7/25/24.
//

import SwiftUI

enum Tab: String, CaseIterable, Hashable {
    case time = "시간"
    case timeline = "타임라인"
}

// MARK: - (S)HomeView
struct HomeView: View {
    // TODO: main에서 Environment 주입으로 변경
    @State private var homeViewModel: HomeViewModel = HomeViewModel()
    @State private var currentDate = Date()
    
    var body: some View {
        NavigationStack {
            ZStack {
               ScrollableTabBar(homeViewModel: homeViewModel)
                
                if homeViewModel.state.isCalendarVisible {
                    CalendarView()
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    CalendarButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    MenuButton()
                }
            })
        }
        
    }
    
    // MARK: - (F)CalendarView
    private func CalendarView() -> some View {
        ZStack(alignment: .topLeading) {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
                .onTapGesture {
                    homeViewModel.effect(.calendarTapped)
                }
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 320, height: 320)
                .foregroundStyle(AppColor.gray0)
                .overlay {
                    DatePicker(
                        "날짜 선택",
                        selection: $currentDate,
                        in: .now...,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .frame(width: 300, height: 300)
                    .onChange(of: currentDate) { _, _ in
                        homeViewModel.effect(.dateTapped(currentDate))
                    }
                }
                .padding()
        }
    }
    
    // MARK: - (F)CalendarButton
    private func CalendarButton() -> some View {
        Button(action: {
            homeViewModel.effect(.calendarTapped)
        }, label: {
            HStack {
                Text(currentDate.pickerFormat)
                    .font(.custom(AppFont.semiBold, size: 18))
                    .foregroundStyle(AppColor.gray4)
                
                Image(systemName: "chevron.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundColor(AppColor.gray4)
                    .rotationEffect(
                        .degrees(
                            homeViewModel.state.isCalendarVisible ? -180 : 0
                        )
                    )
            }
            
        })
    }
    
    // MARK: - (F)MenuButton
    private func MenuButton() -> some View {
        Menu {
            Button(action: {}, label: {
                Label("반복 관리", systemImage: "clock.arrow.circlepath")
            })
            Button(action: {}, label: {
                Label("설정", systemImage: "gear")
            })
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(AppColor.gray4)
        }

    }
}


// MARK: - (S)ScrollableTabBar
fileprivate struct ScrollableTabBar: View {
    @Bindable private var homeViewModel: HomeViewModel
    @State private var scrollPosition: Tab?
    @State private var selectedTabOffset: CGFloat = 0
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        
        UIScrollView.appearance().bounces = false
    }
    
    fileprivate var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                
                TabBar(size: proxy.size)
                
                TabBarItem(size: proxy.size)
                
            }
            .onChange(of: scrollPosition) { _, new in
                withAnimation(.snappy) {
                    homeViewModel.effect(.tabChange(new.unsafelyUnwrapped))
                    selectedTabOffset = (proxy.size.width / 2) * CGFloat(Tab.allCases.firstIndex(of: new.unsafelyUnwrapped) ?? 0)
                }
            }
        }
        
    }
    
    // MARK: - (F)TabBar
    private func TabBar(size: CGSize) -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button(
                    action: {
                        withAnimation {
                            scrollPosition = tab
                        }
                    },
                    label: {
                        Text(tab.rawValue)
                            .font(.custom(AppFont.semiBold, size: 20))
                            .frame(
                                width: (size.width) / 2,
                                height: 40
                            )
                            .padding(.vertical, 12)
                            .foregroundStyle(
                                homeViewModel.state.activeTab == tab
                                ? AppColor.gray5
                                : AppColor.gray2
                            )
                            .contentShape(Rectangle())
                    })
            }
        }
        .overlay(
            Rectangle()
                .frame(width: size.width / 2, height: 4)
                .foregroundStyle(AppColor.mainBlue)
                .offset(x: selectedTabOffset),
            alignment: .bottomLeading
        )
        .frame(width: size.width)
    }
    
    // MARK: - (F)TabBar Item
    private func TabBarItem(size: CGSize) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    VStack {
                        switch tab {
                        case .time:
                            TimerView()
                            
                        // TODO: UseCase 주입 방법 재정리 필요
                        case .timeline:
                            TimelineView(timelineUseCase: TimelineUseCase(appSettingService: TestAppSettingsService(), dailyDataService: TestDailyDataService(), currentDate: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 21, hour: 9, minute: 0))!, isWeelky: false))
                        }
                    }
                    .frame(width: size.width)
                }
            }
            .scrollTargetLayout()
            
        }
        .scrollPosition(id: $scrollPosition)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
    }
}


#Preview {
    HomeView()
}
