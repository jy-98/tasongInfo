//
//  AppState.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/14.
//

import SwiftUI

final class AppState: ObservableObject{
    static let shared = AppState()
    
    @Published var showSplash : Bool = true
    
    private init() {
    }
    
    func doFinishSplash() {
        showSplash = false
    }
    
    //路径
    @Published var rootNavigationPath:[NavigationDestination] = []
    
    func navigate(_ data:NavigationDestination) {
        rootNavigationPath.append(data)
    }
    
    func finishPage(_ count:Int) {
        rootNavigationPath.removeLast(count)
    }
    
}
