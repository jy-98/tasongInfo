//
//  ContactPage.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/15.
//

import SwiftUI

struct ContactPage: View {
    
    @StateObject var viewModel:ContactVM

    
    var body: some View {
        
        VStack(spacing: 0, content: {
            ToMeContent()
            ContactPageContent(viewModel: viewModel)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // 使内容在 VStack 内上对齐
        
        .background(
            Image("center bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped() //如果图片比例与屏幕不匹配，这将防止图片超出边界
        )
        .ignoresSafeArea(.all) // 确保整个内容忽略安全区域
        .onAppear{
            viewModel.show()
        }

      
    }
}
struct ToContactContent:View {
    
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
struct ContactPageContent:View {
    @StateObject var viewModel:ContactVM
    
    var body: some View {
        VStack(spacing: 0){
            Image("ct bg")
                .resizable() // 确保图像可调整大小
                .scaledToFit() // 适应其容器
                .frame(width: 105, height: 105) // 设置图标大小
                .foregroundColor(.blue) // 图标颜色
                .padding(.vertical, 25) // 控制上下内边距

            HStack() {
                Image("person")
                    .resizable() // 确保图像可调整大小
                    .scaledToFit() // 适应其容器
                    .frame(width: 20, height: 20) // 设置图标大小
                    .foregroundColor(.blue) // 图标颜色
                    .padding(.trailing, 14) // 图标与边框之间的内边距
                    .padding(.vertical,15)
                    .padding(.leading,30)

                Text("公司名称:")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                Text("北京盟创伟业科技有限公司")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(Color.white) // 确保背景为白色，与边框颜色形成对比
                .padding(.top,20)
            
            
            HStack() {
                Image("person")
                    .resizable() // 确保图像可调整大小
                    .scaledToFit() // 适应其容器
                    .frame(width: 20, height: 20) // 设置图标大小
                    .foregroundColor(.blue) // 图标颜色
                    .padding(.trailing, 14) // 图标与边框之间的内边距
                    .padding(.vertical,15)
                    .padding(.leading,30)

                Text("公司地址:")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                Text("北京市怀柔区融城北路10号院22号楼305室")
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

                Text("公司邮箱:")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                Text("bj6213@126.com")
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
                    .padding(.vertical,5)
                    .padding(.leading,30)

                Text("公司网址:")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                Text("www.sul2100.cn")
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

                Text("公司电话:")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                Text("13910526419")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(Color.white) // 确保背景为白色，与边框颜色形成对比
                .padding(.top,3)
        }


    }
}




