//
//  DeviceDataPage.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/18.
//

import SwiftUI
struct DeviceDataPage: View {
    @StateObject var viewModel: DeviceDataVM
    @Environment(\.presentationMode) var presentationMode // 环境变量，用于控制页面返回
    
    init(deviceId: String) {
        _viewModel = StateObject(wrappedValue: DeviceDataVM(deviceId: deviceId, completion: { success in
            if success {
                print("数据加载成功")
            } else {
                print("数据加载失败")
            }
        })) // 初始化 @StateObject
    }

    var body: some View {
        DeviceDataPageContent(viewModel: viewModel, deviceDataAll: viewModel.deviceDatas)
            .navigationTitle("设备数据")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                        }
                        .foregroundColor(.white)
                    }
                }
            }
    }
}


struct DeviceDataPageContent: View {
    @ObservedObject var viewModel: DeviceDataVM
    @State private var isRefreshing = false
    @State private var isLoadingMore = false
    var deviceDataAll: [Imei]?

    var body: some View {
        if let dataData = deviceDataAll, !dataData.isEmpty {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(dataData) { imei in
                        ItemDeviceData(device: imei)
                            .padding(.vertical, 6)
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 25)
                .background(
                    Image("center bg")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea(.all)
                )
                .overlay(GeometryReader { geometry in
                    Color.clear
                        .onChange(of: geometry.frame(in: .global).maxY) { value in
                            // 判断是否已经到达底部
                            if value <= UIScreen.main.bounds.height {
                                loadNextPage()  // 当内容完全显示时，加载更多数据
                            }
                        }
                })
            }
            .refreshable {
                isRefreshing = true
                loadData(pageNum: 1)  // 重置为第一页并重新加载
            }
        } else {
            ZStack {
                Image("nulldata")
            }
            .background(
                Image("center bg")
                    .resizable()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height
                    )
                    .scaledToFill()
                    .ignoresSafeArea(.all)
            )
        }
    }

    // 加载第一页数据
    func loadData(pageNum: Int) {
        viewModel.loadData(pageNum: pageNum, pageSize: 10) { success in
            isRefreshing = false  // 刷新结束
            if success {
                print("加载成功")
            } else {
                print("加载失败")
            }
        }
    }

    // 加载更多数据
    func loadNextPage() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        
        let nextPage = viewModel.currentPage + 1
        viewModel.loadData(pageNum: nextPage, pageSize: 10) { success in
            isLoadingMore = false
            if success {
                print("加载更多成功")
            } else {
                print("加载更多失败")
            }
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
