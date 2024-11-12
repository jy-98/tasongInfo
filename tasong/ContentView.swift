//
//  ContentView.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/21.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        MyView()
            .navigationDestination(for: NavigationDestination.self) { destiation in
                switch destiation{
                case let .deviceDetail(deviceId,name):
                    //                    DeviceDetailPage(viewModel: .init(deviceId: deviceId))
                    DeviceDetailPage(deviceId: deviceId,name: name)
                    
                case .deviceData(deviceId: let deviceId):
                    DeviceDataPage(deviceId: deviceId)
                    
                case .deviceControl(deviceId: let deviceId,typeCode : let typeCode):
                    DeviceControlPage(deviceId: deviceId, typeCode: typeCode)
                    
                case .deviceStat(deviceId: let deviceId):
                    DeviceStatPage(deviceId: deviceId)
                    
                case .devicePhoto(deviceId: let deviceId):
                    DevicePhotoPage(deviceId: deviceId)
                case .register:
                    RegisterPage()
                    
                }
            }  .statusBar(hidden: false) // 确保状态栏可见
    }
}

struct MyView: View {
    //    @EnvironmentObject var appState:AppState
    @ObservedObject var appState = AppState.shared
    @AppStorage("authToken") private var authToken: String = ""
    
    var body: some View {
        
        if appState.showSplash {
            SplashPage()
        }else{
            if !authToken.isEmpty {
                MainPage() // 如果已登录，进入主页面
            } else {
                LoginPage(viewmodel: .init()) // 否则显示登录页面
            }
        }
        
        
    }
}


#Preview {
    ContentView()
}
