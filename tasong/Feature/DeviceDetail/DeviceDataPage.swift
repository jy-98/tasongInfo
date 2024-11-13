//
//  DeviceDataPage.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/18.
//

import SwiftUI
struct DeviceDataPage:View{
    
    @StateObject var viewModel:DeviceDataVM
    @Environment(\.presentationMode) var presentationMode // 环境变量，用于控制页面返回
    
    init(deviceId: String) {
        _viewModel = StateObject(wrappedValue: DeviceDataVM(deviceId: deviceId)) // 初始化 @StateObject
        
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
        DeviceDataPageContent(deviceDataAll: viewModel.deviceDatas)
            .navigationTitle("设备数据")  // 设置页面标题
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

struct DeviceDataPageContent:View {
    var deviceDataAll:[Imei]?
    var body: some View {
        if let dataData = deviceDataAll, !dataData.isEmpty{
            ScrollView(.vertical,showsIndicators: false){
                LazyVStack(spacing: 0){
                    ForEach(dataData){ imei in
                        ItemDeviceData(device: imei)
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

struct ItemDeviceData:View {
    var device: Imei // 接收单个设备元素
    
    var body: some View {
        VStack(spacing: 0, content: {
            if let deviceName = device.sendTime {
                Text(deviceName)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading) // 左对齐
                    .fontWeight(.bold)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 0, content: {
                if let deviceData = device.dataArray {
                    ForEach(deviceData) { data in
                        ItemDevData(device: data)
                    }
                }
            })
            .padding(.top,14)
            
            
        })
        .padding(.top,14)
        .padding(.horizontal,5)
        .frame(maxWidth: .infinity) // 使文本占满剩余空间
        .background(.white)
        .cornerRadius(15)
        .padding(10) // 给按钮留出额外的间距，确保阴影有空间展示
        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 2) // 全面阴影
        
    }
}
struct ItemDevData: View {
    var device: DataArray // 接收单个设备元素
    
    var body: some View {
        HStack(spacing: 0) { // 确保 HStack 内部没有间隔
            Text(device.name ?? "") // 使用安全解包
                .font(.system(size: 13))
                .foregroundColor(.black)
                .frame(minWidth: getMinWidth(for: 3)) // 设置最小宽度为五个汉字的宽度
                .frame(alignment: .leading) // 左对齐
                .padding(5)
            
            
            // 格式化显示值，确保只有两位小数，且不添加间隔
            Text("\(String(format: "%.2f", device.value ?? 0.0))\(device.unit ?? "")")
                .font(.system(size: 16))
                .foregroundColor(.blue) // 蓝色文字
        }
        .frame(maxWidth: .infinity, alignment: .leading) // 左对齐
        .padding(5)
    }
}
// 计算五个汉字的宽度
private func getMinWidth(for characterCount: Int) -> CGFloat {
    let averageCharacterWidth: CGFloat = 15 // 假设每个汉字的平均宽度为15点，你可以根据需要调整
    return averageCharacterWidth * CGFloat(characterCount)
}
