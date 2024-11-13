//
//  DeviceStatPVM.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/18.
//

import Foundation
class DeviceStatVM: BaseViewModel {
    
    @Published var deviceChartDatas: [DevChart] = []  // 存储设备详情数据
    
    private let repository: MyNetWorkRepository  // 数据仓库依赖
    var deviceId: String  // 设备号 IMEL
    
    // 初始化时加载数据
    init(repository: MyNetWorkRepository = .shared,deviceId: String) {
        self.repository = repository
        self.deviceId = deviceId
        super.init()
        loadData(deviceId: deviceId,pageNum: 1,pageSize: 10)
    }
    func removeFirstChart() {
            guard !deviceChartDatas.isEmpty else { return } // 确保数组不为空
            let yChartDevice = deviceChartDatas.remove(at: 0) // 删除第一个元素
            print("Removed: \(yChartDevice)") // 输出被移除的元素
        }
    
    // 加载设备详细信息
    func loadData(deviceId: String, pageNum: Int = 1, pageSize: Int = 10) {
        repository.getDeviceChart(deviceId: deviceId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let deviceType):
                    guard let newDatas = deviceType.data, newDatas != self?.deviceChartDatas else {
                        return // 数据相同，避免不必要的更新
                    }
                    print("折线图类型请求成功：\(newDatas)")
                    self?.deviceChartDatas = newDatas
                case .failure(let error):
                    self?.errorMessage = "设备类型请求失败: \(error.localizedDescription)"
                }
            }
        }
    }
}

