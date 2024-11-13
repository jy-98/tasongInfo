//
//  LoginPage.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/21.
//

import SwiftUI
import Kingfisher

struct LoginPage: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var vercode: String = ""
    @State private var isLoginSuccessful: Bool = false
    @StateObject var viewmodel: LoginVM
    @State private var isAgreedToTerms: Bool = false // 新增：存储是否同意协议的状态
    @State private var errorMessage: String? // 用于存储错误信息
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    func login() {
       
        // 检查用户名、密码和验证码是否为空
        guard !username.isEmpty, !password.isEmpty, !vercode.isEmpty else {
            showToastWithMessage("请填写所有字段") // 显示错误消息
            return
        }
        
        guard isAgreedToTerms else {
            // 检查是否同意协议
            showToastWithMessage("请同意用户条款和隐私政策")

            return
        }
    
            // 使用 viewmodel 中的 verCodeBean.uuid
        guard let myuuid = viewmodel.verCodeBean.uuid else { return  } // 获取 UUID
        // 调用登录方法
        viewmodel.login(username: username, password: password, vercode: vercode, myuuid: myuuid) { (success: Bool, errorMessage: String?) in
            if success {
                isLoginSuccessful = true
            } else if let errorMessage = errorMessage {
                self.errorMessage = errorMessage // 使用返回的错误消息
                showToastWithMessage(errorMessage) // 显示错误消息
                viewmodel.loadData()
            }
        }

        // 登录成功后可根据需要处理
        // 示例：使用 isLoginSuccessful 进行 UI 更新
        
        }
    private func showToastWithMessage(_ message: String) {
           toastMessage = message
           showToast = true
       }
    
    var body: some View {
        ZStack{
            
            VStack(alignment: .leading) {

                Text("欢迎进入!")
                    .font(.system(size: 15))
                    .foregroundStyle(.accent)
                    .padding(.top,34)
                
                ZStack(alignment: .leading) {
                  
                    // TextField
                    TextField("用户名/账号", text: $username)
                        .padding(10) // 添加内边距
                        .padding(.leading, 30) // 添加左侧内边距，确保文本不会覆盖图标
                        .foregroundColor(.primary) // 设置文本颜色，自动适应浅色和深色模式
                        .background(Color(.systemBackground)) // 设置系统背景颜色，自动适应浅色和深色模式
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
                        .foregroundColor(.primary) // 设置文本颜色，自动适应浅色和深色模式
                        .background(Color(.systemBackground)) // 设置系统背景颜色，自动适应浅色和深色模式
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

                
                verCodeContent(verCodeBean: viewmodel.verCodeBean,vercode: $vercode)
                    .padding(.top,20)

                
                
                HStack(spacing: 0) {
                    Button(action: {
                        login()
                    }) {
                        Text("登录")
                            .frame(width: 200, height: 40)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }.frame(alignment: .center)
                    
                }.frame(maxWidth: .infinity)
                    .padding(.top,20)
                .padding(.bottom, 80)
                
                if isLoginSuccessful {
                    Text("登录成功!")
                        .foregroundColor(.green)
                        .padding()
                }

                // 注册文本
//                HStack {
//                    Text("没有账号?")
//                        .foregroundColor(.black)
//                    NavigationLink(destination: RegisterPage()) { // 确保 RegisterPage 是您的注册视图
//                        Text("注册")
//                            .foregroundColor(.blue) // 注册文本颜色
//                    }
//                }
//
//                .padding(.top,30)
//                .padding(.bottom, 30)
//                .frame(maxWidth: .infinity)
//                .frame(alignment: .center)// 添加底部间距
            }
            .background {
                Image("center login")
                    .resizable()
                    .frame(height: 430)
                    .frame(width: 320)
            }
            .padding(.horizontal,16)
            .padding(.top,35)
            .padding(.bottom,110)
            .onAppear{
                viewmodel.loadData()
            }
            
            .onChange(of: viewmodel.isLoginSuccessful) { isLoggedIn in
                if isLoggedIn {
                    // 登录成功后跳转到主界面
                    navigateToMainPage()
                }
                
            } .overlay(
                Toast(message: toastMessage, isShowing: $showToast)
                    .padding(.bottom, 50) // Adjust position
            )

            // 同意协议复选框
            HStack(alignment: .bottom) {
                Toggle(isOn: $isAgreedToTerms) {
                    Text("我已阅读并同意《用户条款》《隐私政策》，同时授权 xxxx 使用本账户")
                        .font(.footnote) // 设置字体大小
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading) // 文本左对齐
                }
                .toggleStyle(CheckboxToggleStyle()) // 使用复选框样式
                .frame(maxHeight: .infinity,alignment: .bottom)
            }
            .padding(.horizontal, 16) // 添加横向内边距
            .padding(.bottom, 30) // 添加底部间距
            
        }.padding(.horizontal,17)
        .background {
            Image("bg login")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped() //如果图片比例与屏幕不匹配，这将防止图片超出边界
            
        }
        .padding(.horizontal,44)
        .ignoresSafeArea(.all)
        .onAppear{
            
        }
    }
    
}
private func navigateToMainPage() {
      // 跳转到主界面（可以替换为 Navigation 或页面切换逻辑）
      print("登录成功，进入主页面")
      // 示例：设置 RootView 为 MainPage
      AppState.shared.showSplash = false
  }

struct  verCodeContent:View {
    var verCodeBean: VerCodeBean
    @Binding var vercode: String
    
    var body: some View {
        HStack{
            
            ZStack(alignment: .leading) {
              
                // TextField
                TextField("请输入验证码", text: $vercode)
                    .padding(10) // 添加内边距
                    .padding(.leading, 30) // 添加左侧内边距，确保文本不会覆盖图标
                    .foregroundColor(.primary) // 设置文本颜色，自动适应浅色和深色模式
                    .background(Color(.systemBackground)) // 设置系统背景颜色，自动适应浅色和深色模式
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
            if let image = decodedImage(verCodeBean: verCodeBean) {
                // 将 UIImage 转换为 SwiftUI Image
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill() // 或者使用 .scaledToFit() 视乎需要
                    .frame(width: 80, height: 40) // 明确设置图像宽度和高度
                    .clipped() // 防止超出边界的部分被显示
            } else {
                Text("加载验证码...")
                    .foregroundColor(.black)
            }
        }
    }
}

// 解码 Base64 字符串为 UIImage“”
   func decodedImage( verCodeBean: VerCodeBean) -> UIImage? {
       
       guard let data = Data(base64Encoded: verCodeBean.img ?? "") else {
           return nil
       }
       return UIImage(data: data)
   }
// 自定义复选框样式
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .onTapGesture {
                    configuration.isOn.toggle()
                }
                .foregroundColor(configuration.isOn ? .blue : .gray)
            Spacer()
            configuration.label

        }
        .padding(10)
    }
}

//#Preview {
//    LoginPage()
//}
