//
//  DeviceStatPage.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/18.
//

import SwiftUI
import AAInfographics

struct DeviceStatPage: View {
    
    @StateObject var viewModel: DeviceStatVM
    @Environment(\.presentationMode) var presentationMode // 环境变量，用于控制页面返回
    
    init(deviceId: String) {
        _viewModel = StateObject(wrappedValue: DeviceStatVM(deviceId: deviceId)) // 初始化 @StateObject
        
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
        DeviceChartDataPageContent(deviceChart: viewModel.deviceChartDatas)
            .navigationTitle("设备统计")  // 设置页面标题
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


struct DeviceChartDataPageContent: View {
    var deviceChart: [DevChart]
    
    var body: some View {
        if let firstChart = deviceChart.first, let dataData = firstChart.value, !dataData.isEmpty {
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    // 确保 deviceChart 不为空，并获取第一个图表的数据
                    let xChart: [String] = firstChart.value ?? []
                    //                    let xChart: [String] = dataData.map { String(format: "%.2f", $0) }
                    let validCharts = deviceChart.filter { $0.name != "时间" }
                    
                    // 使用 ForEach 遍历 deviceChart
                    ForEach(validCharts, id: \.id) { chart in
                        GeometryReader { geometry in
                            ItemChart(
                                deviceChart: chart,
                                timeChart: xChart,
                                name: chart.name ?? ""
                            )
                            .frame( height: 200) // 动态设置尺寸
                            .frame(maxWidth: .infinity) // 动态设置尺寸
                            .padding(.top,20)
                            .background(Color.white) // 为每个图表单独设置背景色
                            .cornerRadius(10) // 可选：添加圆角
                            .shadow(color: .gray, radius: 5) // 可选：增加阴影效果
                            //                                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 2) // 全面阴影
                            .padding(.vertical, 30) // 设置垂直间距
                            .padding(.horizontal, 10) // 设置垂直间距
                            .clipShape(RoundedRectangle(cornerRadius: 10)) // 确保圆角生效
                            
                            
                        }
                        .frame(height: 300) // 确保高度固定
                        .cornerRadius(10) // 添加圆角
                        .shadow(color: .gray, radius: 5) // 增加阴影效果
                        .clipShape(RoundedRectangle(cornerRadius: 10)) // 确保圆角生效
                    }
                    
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 5)
            .background(
                Image("center bg")
                    .resizable()
                    .scaledToFill() // 确保填满
                    .ignoresSafeArea(.all) // 确保整个内容忽略安全区域
            )
            
        } else {
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


struct ItemChart: UIViewRepresentable, Equatable {
    var deviceChart: DevChart
    var timeChart: [String]
    var name: String
    
    // Equatable 实现
    static func == (lhs: ItemChart, rhs: ItemChart) -> Bool {
        return lhs.deviceChart.id == rhs.deviceChart.id
    }
    
    // 创建 AAChartView
    func makeUIView(context: Context) -> AAChartView {
        let chartView = AAChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false // 禁用自动调整
        return chartView
    }
    
    // 更新 AAChartView
    func updateUIView(_ uiView: AAChartView, context: Context) {
        //        NSLayoutConstraint.activate([
        //                uiView.widthAnchor.constraint(equalToConstant: 300),
        //                uiView.heightAnchor.constraint(equalToConstant: 200)
        //            ])
        // 打印调试信息，确保数据正确
        print("Chart Name: \(name)")
        print("Time Chart: \(timeChart)")
        print("Chart Data: \(deviceChart.value ?? [])")
        let formattedData = deviceChart.value?.compactMap { Double($0) } ?? []
        
        let chartModel = AAChartModel()
            .chartType(.line) // 设置为折线图
            .categories(timeChart) // X轴分类标签
            .series([
                AASeriesElement()
                    .name(name)
                    .data(formattedData)
            ])
        
        DispatchQueue.main.async {
            uiView.aa_drawChartWithChartModel(chartModel)
        }
    }
}


//#Preview {
//    DeviceStatPage()
//}
