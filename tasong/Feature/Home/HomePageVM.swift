//
//  HomePageVM.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/16.
//

import Foundation
import Moya

class HomePageVM: ObservableObject{
    
    @Published var devList:[DeType] = []
    
    @Published var errorMessage: String? = nil  // 错误信息，用于显示在 UI 中
    
    private let repository: MyNetWorkRepository  // 数据仓库依赖
    
    /// 初始化 ViewModel，支持依赖注入
    init(repository: MyNetWorkRepository = .shared) {
        self.repository = repository
        loadData()  // 初始化时加载数据
    }
    
    
    func loadData(){
        repository.getDeviceTypes { [weak self] result in
            DispatchQueue.main.async {  // 在主线程更新数据
                switch result {
                case .success(let deviceType):
                    print("设备类型请求成功：：：：\(deviceType.msg ?? "")")
                    self?.devList = deviceType.rows ?? []  // 更新设备列表
                    
                case .failure(let error):
                    print("设备类型请求失败：：：：\(error.localizedDescription)")
                    self?.errorMessage = "设备类型请求失败: \(error.localizedDescription)"  // 更新错误信息
                }
            }
        }
    }
    
}
