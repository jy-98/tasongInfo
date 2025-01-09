//
//  DeviceDetailPage.swift
//  设备列表界面
//
//  Created by 贾杨 on 2024/10/17.
//

import SwiftUI

struct DeviceDetailPage: View {
    @StateObject var viewModel:DeviceDetailVM
    @Environment(\.presentationMode) var presentationMode // 环境变量，用于控制页面返回

    init(deviceId: String,name: String) {
        _viewModel = StateObject(wrappedValue: DeviceDetailVM(deviceId: deviceId,name: name)) // 初始化 @StateObject
        
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
        
        DeviceDetailPageContent(deviceTypeAll: viewModel.deviceDetails)
            .navigationTitle(viewModel.name)  // 设置页面标题
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
        //        Text(viewModel.deviceId)
    }
}

struct DeviceDetailPageContent:View {
    var deviceTypeAll:[DeviceAll]?
    
    var body: some View {
        if let deviceTypes = deviceTypeAll{
            if deviceTypeAll?.count != 0{
                ScrollView(.vertical,showsIndicators: false){
                    LazyVStack(spacing: 0){
                        ForEach(deviceTypes){ device in
                            ItemDevice(device: device)
                                .padding(.vertical,6)
                            
                        }
                    }
                }
                .padding(.top,16)
                .padding(.horizontal,25)
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
}

struct ItemDevice:View {
    var device: DeviceAll // 接收单个设备元素
    @State private var showFullTextAlert = false

    var body: some View {
        
        VStack(spacing: 0){
            
            if let deviceName = device.deviceName {
                HStack(alignment: .firstTextBaseline) { // 使用基线对齐确保文本底部对齐
                    HStack(){
                        Text("设备名称:")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        Text(deviceName)
                            .font(.title3) // 更大字体
                            .foregroundColor(.blue) // 蓝色文字
                            .lineLimit(1)
                            .onLongPressGesture {
                                    showFullTextAlert = true
                            }
                            .alert(isPresented: $showFullTextAlert) {
                                Alert(title: Text("完整设备名称"), message: Text(deviceName), dismissButton: .default(Text("关闭")))
                            }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                        .padding(.leading, 15)
                        .padding(.top, 17)
                    
//                    if let isOnline = device.isOnline {
                       
                        HStack(){
                            if(device.isOnline == "1"){
                                Image("online")
                                    .resizable()
                                    .frame(
                                        width: 15,
                                        height: 15
                                    )
                                    .padding(.trailing,1)
                                Text("在线")
                                    .font(.caption2)
                                    .foregroundColor(.black)
                            }else{
                                Image("offline")
                                    .resizable()
                                    .frame(
                                        width: 15,
                                        height: 15
                                    )
                                    .padding(.trailing,1)
                                Text("离线")
                                    .font(.caption2)
                                    .foregroundColor(.black)
                            }
                      
                         
                        }.frame( alignment: .trailing)
                            .padding(.bottom, 10)
                            .padding(.trailing, 15)
                            .padding(.top, 17)
//                    }
                   
                }
            }
            
            if let deviceId = device.imei {
                HStack(alignment: .firstTextBaseline) { // 使用基线对齐确保文本底部对齐
                    Text("设  备  号:")
                        .font(.body)
                        .foregroundColor(.black)
                    
                    Text(deviceId)
                        .font(.title3) // 更大字体
                        .foregroundColor(.blue) // 蓝色文字
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
                .padding(.horizontal, 15)
            }
            
            
            HStack(alignment: .center,spacing: 18){
                NavigationLink(value: NavigationDestination.deviceControl(deviceId: device.imei ?? "",typeCode: device.typeCode ??  "")) {
                    
                    ZStack{
                        HStack(spacing: 0){
                            Image("kongzhi")
                                .frame(
                                    width: 22,
                                    height: 22
                                )
                                .padding(.trailing,8)
                            Text("控制")
                        }
                    }
                    .frame(minWidth: 140,minHeight: 40,alignment: .center)
                    .background(.myGray)
                    .cornerRadius(9)
                }
                
                NavigationLink(value: NavigationDestination.deviceData(deviceId: device.imei ?? "")) {
                    ZStack {
                        HStack(spacing: 0){
                            Image("shuju")
                                .frame(
                                    width: 22,
                                    height: 22
                                )
                                .padding(.trailing,8)
                            Text("数据")
                        }
                    }
                    .frame(minWidth: 140,minHeight: 40,alignment: .center)
                    .background(.myGray)
                    .cornerRadius(9)
                }
               
                
            }
            .padding(.vertical)
            
            HStack(alignment: .center,spacing: 18){
                NavigationLink(value: NavigationDestination.deviceStat(deviceId: device.imei ?? "")) {
                    
                    ZStack {
                        HStack(spacing: 0){
                            Image("tongji")
                                .frame(
                                    width: 22,
                                    height: 22
                                )
                                .padding(.trailing,8)
                            Text("统计")
                        }
                    }
                    .frame(minWidth: 140,minHeight: 40,alignment: .center)
                    .background(.myGray)
                    .cornerRadius(9)
                }
                NavigationLink(value: NavigationDestination.devicePhoto(deviceId: device.imei ?? "")) {
                    
                    ZStack {
                        HStack(spacing: 0){
                            Image("tuxiang")
                                .frame(
                                    width: 22,
                                    height: 22
                                )
                                .padding(.trailing,8)
                            Text("图像")
                        }
                    }
                    .frame(minWidth: 140,minHeight: 40,alignment: .center)
                    .background(.myGray)
                    .cornerRadius(9)
                }
            }
            .padding(.vertical,8)
            .padding(.bottom,17)
            
            
        }
        .frame(maxWidth: .infinity) // 使文本占满剩余空间
        .frame(minHeight: 200)
        .background(.white)
        .cornerRadius(15)
        .padding(10) // 给按钮留出额外的间距，确保阴影有空间展示
        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 2) // 全面阴影
        
        
        
    }
}

//#Preview {
//    DeviceDetailPageContent()
//}
