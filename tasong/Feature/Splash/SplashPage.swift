//
//  SplashPage.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/14.
//

import SwiftUI

struct SplashPage: View {
    
    @StateObject var viewModel = SplashVM()
    
    var body: some View {
        SplashPageContent()
               .edgesIgnoringSafeArea(.all) // 如果需要覆盖整个屏幕，包括状态栏等
               .onAppear(perform: {
                   viewModel.loadData()
               })
    }
}

struct SplashPageContent: View {
    var body: some View {
        ZStack {
                   Image("SplashBanner")
                       .resizable()
                       .aspectRatio(contentMode: .fill)
                       .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                       .clipped() //如果图片比例与屏幕不匹配，这将防止图片超出边界
               }
    }
}


#Preview {
    SplashPage()
}
