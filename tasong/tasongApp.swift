//
//  tasongApp.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/21.
//

import SwiftUI


@main
struct tasongApp: App {
    @ObservedObject var appState = AppState.shared
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appState.rootNavigationPath) {
                ContentView()
                    .ignoresSafeArea() // 忽略安全区域

            }
        }
//        .environmentObject(appState)
    }
}
