//
//  ModernThreeLevelPicker.swift
//  tasong
//
//  Created by 贾杨 on 2025/3/5.
//

import SwiftUI





struct ModernThreeLevelPicker: View {
    @ObservedObject var viewModel: DeviceControlVM
    
    @State private var selectedProvince: SmartData?
    @State private var selectedCity: SmartData?
    @State private var selectedDistrict: SmartData?

    @State private var showSheet = false // 是否展示弹框
    @State private var isLoading = false // 是否正在加载数据
    @State private var showDuplicateAlert = false // 控制是否显示重复提示

    var body: some View {
        ZStack {
            VStack{
                HStack(alignment: .bottom) {
                    Button("新增配置") {
                        isLoading = true // 开始加载数据
                        withAnimation {
                            showSheet = true // 数据加载完成后显示弹框
                        }
                        viewModel.getSmartControl(deviceId: viewModel.deviceId) // 请求数据
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    Button("保存配置") {
                        isLoading = true // 开始加载数据
                        viewModel.sendOrder(
                            data: viewModel.selectedStringItems,
                            deviceId: viewModel.deviceId,
                            startTime: viewModel.configs.startTime,
                            sensorTime: viewModel.configs.sensorTime) // 请求数据
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    
                }
//                let startTimeInt = Binding<Int?>(
//                    get: { viewModel.configs.startTime.flatMap { Int($0) } },
//                    set: { viewModel.configs.startTime = $0.map { String($0) } }
//                )
                let startTimeInt = Binding<Int?>(
                    get: { Int(viewModel.configs.startTime) },  // 直接转换
                    set: { newValue in
                        if let newValue = newValue {
                            viewModel.configs.startTime = String(newValue)  // 转回 String
                        } else {
                            viewModel.configs.startTime = "0"  // 避免 nil 影响
                        }
                    }
                )
                let sensorTimeInt = Binding<Int?>(
                    get: { Int(viewModel.configs.sensorTime) },  // 直接转换
                    set: { newValue in
                        if let newValue = newValue {
                            viewModel.configs.sensorTime = String(newValue)  // 转回 String
                        } else {
                            viewModel.configs.sensorTime = "0"  // 避免 nil 影响
                        }
                    }
                )

//
//                let sensorTimeInt = Binding<Int?>(
//                    get: { viewModel.configs.sensorTime.flatMap { Int($0) } },
//                    set: { viewModel.configs.sensorTime = $0.map { String($0) } }
//                )
                
                NumericInputField(
                    label: "启动时间",
                    value: startTimeInt,
                    minValue: -100,
                    maxValue: 100,
                    onSubmit: {
                        //                        if let motor1Value = viewModel.sporeControls.motor1 {
                        //                            viewModel.getSendSpore(name: "motor1", deviceId: viewModel.deviceId, value: motor1Value)
                        //                        }
                        print("新的 startTime: \(viewModel.configs.startTime)")

                    }
                )
                NumericInputField(
                    label: "采集时间",
                    value: sensorTimeInt,
                    minValue: -100,
                    maxValue: 100,
                    onSubmit: {
                        //                        if let motor1Value = viewModel.sporeControls.motor1 {
                        //                            viewModel.getSendSpore(name: "motor1", deviceId: viewModel.deviceId, value: motor1Value)
                        //                        }
                        print("新的 startTime: \(viewModel.configs.sensorTime)")

                    }
                )
                if viewModel.selectedItems.isEmpty {
                
                } else {
                    List(viewModel.selectedItems, id: \.id) { item in
                        HStack {
                            Text(item.firstName ?? "未知").foregroundColor(.black).frame(maxWidth: .infinity, alignment: .center)
                            Text(item.addressName ?? "未知").foregroundColor(.black).frame(maxWidth: .infinity, alignment: .center)
                            Text(item.sensorName ?? "未知").foregroundColor(.black).frame(maxWidth: .infinity, alignment: .center)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    .listRowSeparatorTint(.white)
                }

                
            }
            .onReceive(viewModel.$smartData) { newData in
                if !newData.isEmpty {
                    isLoading = false
                }
            }
            
            // 自定义弹框
            if showSheet {
                Color.black.opacity(0.4) // 背景遮罩
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showSheet = false // 点击背景关闭弹框
                        }
                    }
                
                VStack {
                    
                    // 选择省市区
                    HStack {
                        BottomSheetView(
                            data: viewModel.smartData,
                            selectedProvince: $selectedProvince,
                            selectedCity: $selectedCity,
                            selectedDistrict: $selectedDistrict,
                            showSheet: $showSheet
                        ){ province, city, district in
                            // ✅ 组合省、市、区并存入列表
                            var newSelections: SmartDataBean = SmartDataBean()
                            if let province = province {
                                newSelections.firstName = province.name
                            }
                            if let city = city {
                                newSelections.addressName = city.name
                            }
                            if let district = district {
                                newSelections.sensorName = district.name
                            }
                            
                            // 先检查是否已经存在
                            let isDuplicate = viewModel.selectedItems.contains(where: {
                                   $0.firstName == newSelections.firstName &&
                                   $0.addressName == newSelections.addressName &&
                                   $0.sensorName == newSelections.sensorName
                               })
                               
                               if isDuplicate {
                                   // 如果是重复的，直接设置提示标志
                                   showDuplicateAlert = true
                               } else {
                                   // 否则添加到列表
                                   viewModel.selectedItems.append(newSelections) // ✅ 添加到列表
                                   viewModel.selectedStringItems.append(district?.id ?? "")

                               }
                           
                        }
                    }
                    
                   
                }  .frame(height: UIScreen.main.bounds.height / 3) // **真实的屏幕 1/4 高度**
                    .background(Color.white) // **自定义背景颜色，去掉系统默认背景**
                    .cornerRadius(20) // 可选，设置圆角效果
                    .shadow(radius: 10) // 可选，添加阴影效果
                    .presentationDetents([.medium]) // 可选，用于设置弹框在 iOS 16 及以上版本的高度限制
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("完成") {
                                showSheet = false
                            }
                        }
                    }
                    .animation(.spring(), value: showSheet)
            }
        }.alert(isPresented: $showDuplicateAlert) {
            Alert(
                title: Text("提示"),
                message: Text("该配置已添加过，请勿重复添加。"),
                dismissButton: .default(Text("确定"))
            )
        }.onAppear {
            viewModel.updateSelectedItems()
        }
        .onChange(of: viewModel.smartData) { _ in
            viewModel.updateSelectedItems()
        }
    }
}
