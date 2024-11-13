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
    
    private let repository: MyNetWorkRepository  // 数据仓库依赖
    var deviceId: String  // 设备号 IMEL
    
    // 初始化时加载数据
    init(repository: MyNetWorkRepository = .shared,deviceId: String) {
        self.repository = repository
        self.deviceId = deviceId
        super.init()
        loadData(deviceId: deviceId,pageNum: 1,pageSize: 10)
    }
    
    // 加载设备详细信息
    func loadData(deviceId: String,pageNum: Int = 1, pageSize: Int = 10) {
        repository.getDeviceData(deviceId: deviceId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let deviceType):
                    print("设备类型请求成功：\(deviceType.msg ?? "")")
                    self?.deviceDatas = deviceType.rows ?? []
                case .failure(let error):
                    self?.errorMessage = "设备类型请求失败: \(error.localizedDescription)"
                }
            }
        }
      
    }
}
