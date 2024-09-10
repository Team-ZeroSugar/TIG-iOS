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
  @Environment(HomeViewModel.self) var homeViewModel
  
  var body: some View {
    NavigationStack {
      ZStack {
        AppColor.background.ignoresSafeArea()
        
        ScrollableTabBar(homeViewModel: homeViewModel)
          .ignoresSafeArea(edges: .bottom)
        
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
        .foregroundStyle(AppColor.gray01)
        .overlay {
          DatePicker(
            "날짜 선택",
            selection: .init(
              get: { homeViewModel.state.currentDate },
              set: { homeViewModel.effect(.dateTapped($0)) }
            ),
            in: .now...,
            displayedComponents: [.date]
          )
          .datePickerStyle(.graphical)
          .frame(width: 300, height: 300)
//          .onChange(of: currentDate) { _, _ in
//            homeViewModel.effect(.dateTapped(currentDate))
//          }
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
        Text(homeViewModel.state.currentDate.pickerFormat)
          .font(.custom(AppFont.semiBold, size: 18))
          .foregroundStyle(AppColor.gray04)
        
        Image(systemName: "chevron.down")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 16, height: 16)
          .foregroundColor(AppColor.gray04)
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
      NavigationLink {
        WeeklyRepeatView()
      } label: {
        Label("반복 관리", systemImage: "clock.arrow.circlepath")
      }
      
      NavigationLink {
        SettingView()
      } label: {
        Label("설정", systemImage: "gear")
      }
    } label: {
      Image(systemName: "ellipsis")
        .foregroundStyle(AppColor.gray04)
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
              .font(.custom(AppFont.semiBold, size: 18))
              .frame(
                width: (size.width) / 2,
                height: 40
              )
              .padding(.vertical, 12)
              .foregroundStyle(
                homeViewModel.state.activeTab == tab
                ? AppColor.gray05
                : AppColor.gray02
              )
              .contentShape(Rectangle())
          })
      }
    }
    .overlay(
      Rectangle()
        .frame(width: size.width / 2, height: 4)
        .foregroundStyle(AppColor.blueMain)
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
              
            case .timeline:
              TimelineView()
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
    .environment(HomeViewModel())
}
