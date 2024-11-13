//
//  DeviceDetailVM.swift
//  设备列表
//
//  Created by 贾杨 on 2024/10/17.
//
import Foundation
import Moya

class DeviceDetailVM: BaseViewModel {
    @Published var deviceDetails: [DeviceAll] = []  // 存储设备详情数据
    
    private var provider = MoyaProvider<MyNetWorkService>()  // Moya 请求提供者
    var deviceId: String  // 设备 ID
    @Published var name: String  // 设备 ID
    
    // 初始化时加载数据
    init(deviceId: String,name: String) {
        self.deviceId = deviceId
        self.name = name
        super.init()
        loadData(deviceId: deviceId,pageNum: 1,pageSize: 10)
    }
    
    // 加载设备详细信息
    func loadData(deviceId: String,pageNum: Int = 1, pageSize: Int = 10) {
        provider.request(.deviceInfo(deviceId: deviceId, pageNum: pageNum, pageSize: pageSize)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    do {
                        let responseString = String(data: response.data, encoding: .utf8) ?? "无效的响应"
                        print("设备详情响应数据：\(responseString)")
                        
                        let deviceInfo = try response.map(DeviceAllBean.self)
                        self?.deviceDetails = deviceInfo.data ?? []  // 更新设备详情列表
                    } catch {
                        print("JSON 解析失败：\(error.localizedDescription)")
                        self?.errorMessage = "设备详情解析失败: \(error.localizedDescription)"
                    }
                case .failure(let error):
                    print("设备详情请求失败：\(error.localizedDescription)")
                    self?.errorMessage = "设备详情请求失败: \(error.localizedDescription)"
                }
            }
        }
    }
}
