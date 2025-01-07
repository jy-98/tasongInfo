//
//  MePage.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/15.
//

import SwiftUI

struct MePage: View {
    @StateObject var viewModel:MeVM
    
    var body: some View {
        VStack(spacing: 0, content: {
            ToMeContent()
            MePageContent(userbean: viewModel.userbean)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // 使内容在 VStack 内上对齐
        .background(
            Image("center bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped() //如果图片比例与屏幕不匹配，这将防止图片超出边界
        )
        .ignoresSafeArea(.all) // 确保整个内容忽略安全区域
        .onAppear{
           viewModel.show()
       }
    }
}

struct ToMeContent:View {
    
    var body: some View {
        ZStack {
            Image("top bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: 107
                )
                .clipped()

        }
    }
}

struct MePageContent:View {
    var userbean: UserBean
    
    var body: some View {
        
        VStack(spacing: 0){
            
            HStack(spacing: 0) {
                AsyncImage(url: URL(string: "\(Config.IPADDRESS)\(userbean.data?.avatar ?? "")")) { phase in
                    switch phase {
                    case .empty:
                        // 图片正在加载时显示占位符
                        ProgressView()  // 或者可以显示一个自定义的占位图标
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 68, height: 68)
                            .foregroundColor(.blue)
                            .clipShape(Circle())  // 将占位符裁剪为圆形
                    case .success(let image):
                        // 加载成功，显示图片
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 68, height: 68)
                            .clipShape(Circle())  // 将图片裁剪为圆形
                    case .failure(_):
                        // 加载失败时显示一个错误占位图像
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 68, height: 68)
                            .foregroundColor(.red)
                            .clipShape(Circle())  // 将错误图标裁剪为圆形
                    @unknown default:
                        // 处理其他未知情况
                        EmptyView()
                    }
                }
                .padding(.vertical, 34)

                
                VStack(spacing: 0) {
                    Text(userbean.data?.userName ?? "")
                        .font(.system(size: 17))
                        .padding(.bottom, 18)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading) // 左对齐文本
                    
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("邮箱：")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                            .foregroundStyle(.secondary)
                        
                        Text(userbean.data?.email ?? "")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // 确保 HStack 左对齐
                }
                .padding(.leading, 10) // 控制 VStack 与图标之间的间距
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.horizontal,40)
            .background(Color.white) // 确保背景为白色，与边框颜色形成对比
            
            HStack() {
                Image("shouji")
                    .resizable() // 确保图像可调整大小
                    .scaledToFit() // 适应其容器
                    .frame(width: 20, height: 20) // 设置图标大小
                    .foregroundColor(.blue) // 图标颜色
                    .padding(.trailing, 14) // 图标与边框之间的内边距
                    .padding(.vertical,15)
                    .padding(.leading,30)
                
                Text("手机号码:")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                Text(userbean.data?.phonenumber ?? "")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(Color.white) // 确保背景为白色，与边框颜色形成对比
            .padding(.top,40)
            
            HStack() {
                Image("bumen")
                    .resizable() // 确保图像可调整大小
                    .scaledToFit() // 适应其容器
                    .frame(width: 20, height: 20) // 设置图标大小
                    .foregroundColor(.blue) // 图标颜色
                    .padding(.trailing, 14) // 图标与边框之间的内边距
                    .padding(.vertical,15)
                    .padding(.leading,30)
                
                Text("所属部门名称:")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                Text(userbean.postGroup ?? "")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(Color.white) // 确保背景为白色，与边框颜色形成对比
            .padding(.top,3)
            
            
            HStack() {
                Image("person")
                    .resizable() // 确保图像可调整大小
                    .scaledToFit() // 适应其容器
                    .frame(width: 20, height: 20) // 设置图标大小
                    .foregroundColor(.blue) // 图标颜色
                    .padding(.trailing, 14) // 图标与边框之间的内边距
                    .padding(.vertical,15)
                    .padding(.leading,30)
                
                Text("所属角色:")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                Text(userbean.data?.nickName ?? "")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(Color.white) // 确保背景为白色，与边框颜色形成对比
            .padding(.top,3)
            
            
            HStack() {
                Image("riqi")
                    .resizable() // 确保图像可调整大小
                    .scaledToFit() // 适应其容器
                    .frame(width: 20, height: 20) // 设置图标大小
                    .foregroundColor(.blue) // 图标颜色
                    .padding(.trailing, 14) // 图标与边框之间的内边距
                    .padding(.vertical,15)
                    .padding(.leading,30)
                
                Text("创建日期:")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                Text(userbean.data?.createTime ?? "")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(Color.white) // 确保背景为白色，与边框颜色形成对比
            .padding(.top,3)
            .padding(.bottom,205)
            
            
            HStack() {
                Button(action: {
                    // 清空保存的 token
                           UserDefaults.standard.removeObject(forKey: "authToken")
                           UserDefaults.standard.removeObject(forKey: "authUser")

                           // 执行退出登录的操作
                           AppState.shared.doFinishSplash()
                }, label: {
                    Text("退出登录")
                        .font(.system(size: 17))
                        .foregroundStyle(.red)
                        .padding(.vertical,15)
                })
                
                
            }
            .frame(maxWidth: .infinity,alignment: .center)
            .background(Color.white) // 确保背景为白色，与边框颜色形成对比
            
        }
        
        
    }
}
//#Preview {
//    MePage()
//}
