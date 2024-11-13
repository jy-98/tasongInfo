//
//  MainPage.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/14.
//

import SwiftUI

struct MainPage: View {
    
    var body: some View {
        MainPageContent()
    }
}

struct MainPageContent: View {
    @State private var selectedIndex = 0

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedIndex) {
                HomePage(viewmodel: .init())
                    .tag(0)
                    .id(0)
                    .ignoresSafeArea() // 添加这个可以确保整个内容忽略安全区域

                    
                ContactPage(viewModel: .init()  )
                    .tag(1)
                    .id(1)
                    .ignoresSafeArea() // 添加这个可以确保整个内容忽略安全区域


                MePage(viewModel: .init())
                    .tag(2)
                    .id(2)
                    .ignoresSafeArea() // 添加这个可以确保整个内容忽略安全区域


            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 隐藏默认的TabBar
            
            HStack(spacing: 0) {
                Button(action: { selectedIndex = 0 }) {
                    VStack {
                        Image(selectedIndex == 0 ? "home" : "home selected")
                            .frame(width: 30,height: 30)
                        Text("Home")
                            .font(.system(size: 10))
                            .foregroundColor(selectedIndex == 0 ? .accentColor : .gray) // 使用accentColor
                    }
                }


                Spacer()

                Button(action: { selectedIndex = 1 }) {
                    VStack {
                        Image(selectedIndex == 1 ? "contact" : "contact selected")
                            .frame(width: 30,height: 30)
                        Text("Contact")
                            .font(.system(size: 10))
                            .foregroundColor(selectedIndex == 1 ? .accentColor : .gray) // 使用accentColor

                    }
                }

                Spacer()

                Button(action: { selectedIndex = 2 }) {
                    VStack {
                        Image(selectedIndex == 2 ? "me" : "me selected")
                            .frame(width: 30,height: 30)
                        Text("Me")
                            .font(.system(size: 10))
                            .foregroundColor(selectedIndex == 2 ? .accentColor : .gray) // 使用accentColor

                    }
                }

            }
            .padding(.top, 17) // 为底部添加额外的间距
            .padding(.bottom, 13) // 为底部添加额外的间距
            .padding(.horizontal, 35) // 为底部添加额外的间距
            .background(Color.white) // 可选：设置背景颜色
            .ignoresSafeArea() // 添加这个可以确保整个内容忽略安全区域

        }
        
//        .edgesIgnoringSafeArea(.all) // 应用在 ZStack 上，确保覆盖所有区域
        .ignoresSafeArea(.all)

    }
}


#Preview {
    MainPage()
}
