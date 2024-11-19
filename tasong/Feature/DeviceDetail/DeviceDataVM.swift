//
//  DeviceDataVM.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/18.
//

import Foundation
import Moya
class DeviceDataVM: BaseViewModel {
    @Published var deviceDatas: [Imei] = []  // 存储设备详情数据
    @Published var isLoading: Bool = false    // 用来指示是否正在加载
    @Published var currentPage: Int = 1        // 当前页码
    private let pageSize: Int = 10            // 每页的数据数量

    private let repository: MyNetWorkRepository  // 数据仓库依赖
    var deviceId: String  // 设备号 IMEI
    
    // 初始化时加载数据
    init(repository: MyNetWorkRepository = .shared, deviceId: String, completion: @escaping (Bool) -> Void) {
        self.repository = repository
        self.deviceId = deviceId
        super.init()
        loadData(pageNum: currentPage, completion: completion)  // 默认加载第一页
    }
    
    // 加载设备数据，回调方式
    func loadData(pageNum: Int = 1, pageSize: Int = 10, completion: @escaping (Bool) -> Void) {
        guard !isLoading else { return }
        isLoading = true  // 设置为加载中
        
        repository.getDeviceData(deviceId: deviceId, pageNum: pageNum, pageSize: pageSize) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let deviceType):
                    // 如果是第一页，替换数据，否则追加数据
                    if pageNum == 1 {
                        self?.deviceDatas = deviceType.rows ?? []
                    } else {
                        self?.deviceDatas.append(contentsOf: deviceType.rows ?? [])
                    }
                    self?.currentPage = pageNum  // 更新当前页码
                    completion(true)  // 加载成功
                case .failure(let error):
                    self?.errorMessage = "设备类型请求失败: \(error.localizedDescription)"
                    completion(false)  // 加载失败
                }
                self?.isLoading = false  // 设置为加载完成
            }
        }
    }
}
