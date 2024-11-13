//  DeviceControlPage.swift
//  tasong
//
//  Created by 贾杨 on 2024/11/1.
//

import SwiftUI

struct DeviceControlPage: View {
    @StateObject var viewModel: DeviceControlVM
    @Environment(\.presentationMode) var presentationMode // 环境变量，用于控制页面返回
    
    @State private var messageToSend: String = ""  // 用户输入的消息

    init(deviceId: String,typeCode : String) {
        _viewModel = StateObject(wrappedValue: DeviceControlVM(deviceId: deviceId,typeCode: typeCode))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundImage = UIImage(named: "toolbar")
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack {
            DeviceControlPageContent(viewModel: viewModel)
//
//            // 显示接收到的消息
//            Text("收到的消息：\(viewModel.controlData)")
//                .padding()
//
//            // 输入框和发送按钮
//            HStack {
//                TextField("输入消息", text: $messageToSend)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//
//                Button(action: {
//                    viewModel.sendMessage(messageToSend) // 发送消息
//                    messageToSend = "" // 清空输入框
//                }) {
//                    Text("发送")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
//            }
        }
        .navigationTitle("设备控制")
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
        
        // 使用 onAppear 和 onDisappear 管理 WebSocket 连接生命周期
        .onAppear {
            viewModel.connectWebSocket()
        }
        .onDisappear {
            viewModel.disconnectWebSocket()
        }
    }
}

struct DeviceControlPageContent: View {
    @ObservedObject var viewModel: DeviceControlVM

    var body: some View {
        VStack {
            // 检查 controlData 是否为空
            if viewModel.deviceControls.isEmpty {
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
            } else {
                // 使用 ZStack 来设置 List 背景为透明
                ZStack {
                    Color.clear // 设置 ZStack 背景为透明
                    List {
                        // 过滤出有效的控制项，只显示 control.key 不为 nil 的项
                        ForEach(viewModel.deviceControls.filter { $0.key != nil }) { control in
                            HStack {
                                Text(control.key ?? "Unknown")
                                    .foregroundColor(.black) // 控制项名称
                                
                                Spacer()
                                
                                Toggle(isOn: Binding(
                                                   get: { control.value == 1 },
                                                   set: { newValue in
                                                       // 当开关状态改变时，发送新的控制状态
                                                       viewModel.updateControl(control: control, newValue: newValue)
                                                   }
                                               )) {
                                                   EmptyView()
                                               }
                                               .toggleStyle(SwitchToggleStyle(tint: .blue)) // 开时蓝色
                                               .disabled(false) // 启用 Toggle
                                .padding(.trailing, 8)
                            }
                            .padding(.vertical, 16) // 增加上下内边距以增加行高
                            .frame(height: 60) // 设置每行的高度
                            .listRowBackground(Color.clear) // 设置每行的背景颜色为透明
                        }
                    }
                    .listStyle(PlainListStyle()) // 使用无样式列表
                    .listRowSeparatorTint(.white) // 设置行分隔符颜色为白色

                }.background(
                    Image("center bg")
                        .resizable()
                        .scaledToFill() // 确保填满
                        .ignoresSafeArea(.all) // 确保整个内容忽略安全区域
                )
            }
        }
    }
}
// 自定义 Toggle 样式
struct SmallSwitchToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(configuration.isOn ? Color.blue : Color.gray)
                .frame(width: 65, height: 31) // 背景开关的大小保持不变
                .overlay(
                    HStack {
                        // 根据状态显示开或关的文字
                        if configuration.isOn {
                            Text("开")
                                .foregroundColor(.white)
                                .font(.system(size: 17))
                                .padding(.leading, 6)
                        }
                        Spacer()
                        
                        // 使用本地图片资源替换白色按钮，并减小大小
                        Image(configuration.isOn ? "buttonOn" : "buttonOff") // 替换为本地图片
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22) // 设置滑块的大小
                            .padding(configuration.isOn ? .trailing : .leading, 2)
                        
                        Spacer()
                        if !configuration.isOn {
                            Text("关")
                                .foregroundColor(.white)
                                .font(.system(size: 17))
                                .padding(.trailing, 6)
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle() // 切换开关状态
                }
        }
    }
}

//struct DeviceControlPage_Previews: PreviewProvider {
//    static var previews: some View {
//        DeviceControlPage(deviceId: "sampleDeviceID")
//    }
//}
