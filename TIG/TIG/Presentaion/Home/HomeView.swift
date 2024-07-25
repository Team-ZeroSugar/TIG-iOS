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

// MARK: - HomeView
struct HomeView: View {
    // TODO: main에서 Environment 주입으로 변경
    @State private var homeViewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack {
                    Spacer().frame(height: 80)
                    
                    ScrollableTabBar(homeViewModel: homeViewModel)
                }
                
                if homeViewModel.state.isCalendarVisible {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .onTapGesture {
                            homeViewModel.effect(.calendarTapped)
                        }
                }
                
                NavigationBar(homeViewModel: homeViewModel)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
            }
            
        }
        
    }
}

// MARK: - NavigationBar
fileprivate struct NavigationBar: View {
    @Bindable private var homeViewModel: HomeViewModel
    @State private var currentDate = Date()
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    fileprivate var body: some View {
        VStack(alignment: .leading) {
            HStack {
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
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(AppColor.gray4)
                }
            }
            
            if homeViewModel.state.isCalendarVisible {
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

                    }
            }
        }
        .padding(.vertical, 13)
        .onChange(of: currentDate) { _, _ in
            homeViewModel.effect(.dateTapped(currentDate))
        }
    }
}


// MARK: - ScrollableTabBar
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
            VStack {
                
                // MARK: - 탭바
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
                                        width: (proxy.size.width) / CGFloat(Tab.allCases.count),
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
                        .frame(width: proxy.size.width / 2, height: 4)
                        .foregroundStyle(AppColor.mainBlue)
                        .offset(x: selectedTabOffset),
                    alignment: .bottomLeading
                )
                .frame(width: proxy.size.width)
                
                // MARK: - 탭바 아이템
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(Tab.allCases, id: \.self) { tab in
                            VStack {
                                switch tab {
                                case .time:
                                    Text("시간")
                                case .timeline:
                                    Text("타임라인")
                                }
                            }
                            .frame(width: proxy.size.width)
                        }
                    }
                    .scrollTargetLayout()
                    
                }
                .scrollPosition(id: $scrollPosition)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                
            }
            .onChange(of: scrollPosition) { _, new in
                withAnimation(.snappy) {
                    homeViewModel.effect(.tabChange(new.unsafelyUnwrapped))
                    selectedTabOffset = (proxy.size.width / CGFloat(Tab.allCases.count)) * CGFloat(Tab.allCases.firstIndex(of: new.unsafelyUnwrapped) ?? 0)
                }
            }
        }
        
    }
}

#Preview {
    HomeView()
}
