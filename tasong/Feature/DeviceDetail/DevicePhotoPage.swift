//
//  DevicePhotoPage.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/18.
//

import SwiftUI
import Kingfisher

struct DevicePhotoPage: View {
    
    @StateObject var viewModel:DevicePhotoVM
    @Environment(\.presentationMode) var presentationMode // 环境变量，用于控制页面返回
    
    init(deviceId: String) {
        _viewModel = StateObject(wrappedValue: DevicePhotoVM(deviceId: deviceId)) // 初始化 @StateObject
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground() // 移除默认背景
        appearance.backgroundImage = UIImage(named: "toolbar") // 设置背景图
        // 修改标题文字的颜色和字体
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white, // 标题文字颜色
            .font: UIFont.boldSystemFont(ofSize: 18) // 标题文字字体
        ]
        UINavigationBar.appearance().tintColor = .white
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        DevicePhotoDataPageContent(devicePhotoAll: viewModel.devicePhotoDatas)
            .navigationTitle("设备图像")  // 设置页面标题
            .navigationBarTitleDisplayMode(.inline) // 控制标题显示模式 (large/inline)
            .navigationBarBackButtonHidden(true) // 隐藏默认返回按钮
        
            .toolbar {
                // 自定义导航栏左侧按钮（替换默认返回按钮）
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // 返回上一页
                        // 自定义返回操作，例如 pop
                    }) {
                        HStack {
                            Image(systemName: "chevron.left") // 自定义返回图标
                        }
                        .foregroundColor(.white) // 设置颜色
                    }
                }
            }
    }
}

struct DevicePhotoDataPageContent:View{
    var devicePhotoAll:[DataPhoto]?
    var body: some View {
        if let dataData = devicePhotoAll, !dataData.isEmpty{
            ScrollView(.vertical,showsIndicators: false){
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 0, content: {
                    if let devicePhoto = devicePhotoAll {
                        ForEach(devicePhoto) { data in
                            ItemDevPhoto(dataPhoto: data)
                        }
                    }
                })
            }
            .background(
                Image("center bg")
                    .resizable()
                    .scaledToFill() // 确保填满
                    .ignoresSafeArea(.all) // 确保整个内容忽略安全区域
            )
        }else{
            ZStack{
                Image("nulldata")
            } .background(
                Image("center bg")
                    .resizable()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height
                    )
                    .scaledToFill() // 确保填满
                    .ignoresSafeArea(.all) // 确保整个内容忽略安全区域
            )
            
        }
        
    }
}

struct ItemDevPhoto:View {
    var dataPhoto: DataPhoto // 接收单个设备元素
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if let imageUrl = dataPhoto.fileName, let url = URL(string: "\(Config.IMGADDRESS)\(imageUrl)") {
                    KFImage(url)
                        .resizable()
                        .placeholder {
                            ProgressView() // 显示加载指示器
                                .frame(height: 200)
                        }
                        .cancelOnDisappear(true)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 15)) // 图片也裁剪为圆角
                } else {
                    // 无效 URL 时的占位图
                    Image(systemName: "photo")
                        .resizable()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                if let time = dataPhoto.createTime {
                    Text(time)
                        .font(.system(size: 16))
                        .foregroundColor(.blue) // 蓝色文字
                }
            }
            .background(
                Color.white
                    .clipShape(RoundedRectangle(cornerRadius: 15)) // 背景裁剪为圆角
            )
            .clipShape(RoundedRectangle(cornerRadius: 15)) // 外层也裁剪为圆角
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 6)
    }
    
}
//#Preview {
//    DevicePhotoPage()
//}
