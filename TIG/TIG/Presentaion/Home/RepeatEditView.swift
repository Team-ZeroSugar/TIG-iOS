//
//  RepeatEditView.swift
//  TIG
//
//  Created by 신승재 on 8/7/24.
//

import SwiftUI

struct RepeatEditView: View {
    var body: some View {
        VStack {
            TopNavigationView()
                .padding(EdgeInsets(top: 11,
                                    leading: 8,
                                    bottom: 11,
                                    trailing: 20))
            
            
            
            Spacer()
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
fileprivate 

#Preview {
    RepeatEditView()
}
