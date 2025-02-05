//
//  HomePage.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/15.
//

import SwiftUI
import Kingfisher

struct HomePage: View {
    
    @StateObject var viewmodel: HomePageVM
    
    var body: some View {
        
        homePageContent(deviceTypeAll: viewmodel.devList).ignoresSafeArea(.all)
        
    }
}
struct homePageContent:View {
    var deviceTypeAll:[DeType]
    
    
    var body: some View {
        VStack(spacing: 0, content: {
            TopGroundContent()
            CenterGroundContent(deviceTypeAll: deviceTypeAll)
        })
        .ignoresSafeArea(.all) // 确保整个内容忽略安全区域

        
    }
}

struct TopGroundContent:View {
    
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
            
            HStack(spacing: 0){
                Spacer() // 推动内容到右侧
                Image(systemName: "qrcode.viewfinder")
                    .font(.system(size: 20))
                    .padding(.top, 16)
                    .padding(.trailing, 31)
            }
        }
    }
}

struct CenterGroundContent:View {
    var deviceTypeAll:[DeType]
    
    var body: some View {
        ZStack(){
            ScrollView(.vertical,showsIndicators: false){
                VStack(spacing: 0, content: {
                    Text("device overall")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading) // 左对齐
                        .fontWeight(.bold)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 0, content: {
                        
                        ForEach(deviceTypeAll) { device in
                            
                            NavigationLink(value: NavigationDestination.deviceDetail(deviceId: device.id ?? "",name: device.name ?? "")) {
                                ItemDeviceType(device: device)
                            }
                            
                        }
                        
                        
                    })
                    .padding(.top,14)
                    
                })
                
            }
            .padding(.top,16)
            .padding(.horizontal,24)
            .background(
                Image("center bg")
                    .resizable()
                    .scaledToFill() // 确保填满
                    .ignoresSafeArea(.all) // 确保整个内容忽略安全区域
            )
        }
        .ignoresSafeArea() // 添加这个可以确保整个内容忽略安全区域

    }
}

struct ItemDeviceType: View {
    
    var device: DeType
    
    var body: some View {
        
        ZStack{
            HStack(spacing: 0, content: {
                if let imageUrl = device.imageUrl {
                    let fullImageUrl = Config.IPADDRESS + imageUrl
                    if let encodedUrl = fullImageUrl
                        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                       let url = URL(string: encodedUrl) {
                        KFImage(url)
                            .resizable()
                            .placeholder {
                                ProgressView() // Show a loading indicator
                                    .frame(width: 29, height: 29)
                            }
                            .cancelOnDisappear(true)
                            .frame(width: 29, height: 29)
                    } else {
                        // Fallback image if URL is not valid
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 29, height: 29)
                    }
                }

                
                Text(device.name ?? "Unknown Device")
                    .foregroundColor(.black)
                    .padding(.leading,11)
                    .frame(maxWidth: .infinity, alignment: .leading) // 使文本占满剩余空间
                    .lineLimit(1) // 限制为一行
                    .truncationMode(.tail) // 超出部分以省略号显示
                
            })
            
            .padding(18) // 添加一些内边距
            .background(Color.white) // 设置背景颜色为白色
            .cornerRadius(20) // 设置圆角半径为20
            .shadow(radius: 1) // 可选：添加阴影效果
        }.padding(.vertical,6)
        
    }
}

//#Preview {
//    HomePage()
//}
