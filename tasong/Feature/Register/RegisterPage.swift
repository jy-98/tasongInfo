//
//  RegisterPage.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/22.
//

import SwiftUI

struct RegisterPage: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    @StateObject var viewModel:RegisterVM
    @Environment(\.presentationMode) var presentationMode // 环境变量，用于控制页面返回

    init() {
        _viewModel = StateObject(wrappedValue: RegisterVM()) // 初始化 @StateObject
        
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
        
        RegisterPageContent(username: $username, password: $password,viewModel: viewModel)
            .navigationTitle("注册账号")  // 设置页面标题
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

struct RegisterPageContent:View {
    @Binding  var username: String
    @Binding  var password: String
    @StateObject var viewModel:RegisterVM

    func register() {

    // 检查用户名、密码和验证码是否为空
//        guard username.isEmpty, password.isEmpty, vercode.isEmpty else {
//            errorMessage = "请填写所有字段"
//            return
//        }

        viewModel.getRegister(username: username, password: password, nickname: nil)

    
    }
    
    var body: some View {
        VStack(spacing: 0){
            ZStack(alignment: .leading) {
              
                // TextField
                TextField("用户名/账号", text: $username)
                    .padding(10) // 添加内边距
                    .padding(.leading, 30) // 添加左侧内边距，确保文本不会覆盖图标
                    .background(Color.white) // 确保背景为白色，与边框颜色形成对比
                    .cornerRadius(5) // 设置圆角
                    .overlay(
                        RoundedRectangle(cornerRadius: 5) // 创建一个圆角矩形
                            .stroke(Color.blue, lineWidth: 2) // 设置边框颜色和宽度
                    )
                // 在 TextField 背景下放置图标
                Image("person") // 使用你的图像名
                    .resizable() // 确保图像可调整大小
                    .scaledToFit() // 适应其容器
                    .frame(width: 20, height: 20) // 设置图标大小
                    .foregroundColor(.blue) // 图标颜色
                    .padding(.leading, 10) // 图标与边框之间的内边距
                
            }                    .padding(.top,20)

            
            
            ZStack(alignment: .leading) {
              
                // TextField
                SecureField("密码", text: $password)
                    .padding(10) // 添加内边距
                    .padding(.leading, 30) // 添加左侧内边距，确保文本不会覆盖图标
                    .background(Color.white) // 确保背景为白色，与边框颜色形成对比
                    .cornerRadius(5) // 设置圆角
                    .overlay(
                        RoundedRectangle(cornerRadius: 5) // 创建一个圆角矩形
                            .stroke(Color.blue, lineWidth: 2) // 设置边框颜色和宽度
                    )
                // 在 TextField 背景下放置图标
                Image("bg ps") // 使用你的图像名
                    .resizable() // 确保图像可调整大小
                    .scaledToFit() // 适应其容器
                    .frame(width: 20, height: 20) // 设置图标大小
                    .foregroundColor(.blue) // 图标颜色
                    .padding(.leading, 10) // 图标与边框之间的内边距
                
            }
            .padding(.top,20)
            
            HStack(spacing: 0) {
                Button(action: {
                    register()
                }) {
                    Text("立即注册")
                        .frame(width: 200, height: 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }.frame(alignment: .center)
                
            }.frame(maxWidth: .infinity)
                .padding(.top,20)
        }
        .padding(.horizontal,54)
        .background(
            Image("center bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped() //如果图片比例与屏幕不匹配，这将防止图片超出边界
        )                .ignoresSafeArea(.all) // 确保整个内容忽略安全区域


    }
}

