// MyNetWorkRepository.swift
// mengchuang
// Created by 贾杨 on 2024/10/16.
import Foundation
import Moya

class MyNetWorkRepository {
    
    // 单例实例
    static let shared = MyNetWorkRepository()
    private let provider: MoyaProvider<MyNetWorkService>  // 网络请求 Provider
    
    // 是否启用调试日志（可选）
    private let isLoggingEnabled = true
    
    // 允许传入自定义 Provider，方便测试或不同配置下使用
    init(provider: MoyaProvider<MyNetWorkService> = MoyaProvider<MyNetWorkService>()) {
        self.provider = provider
    }



    // MARK: - 通用请求方法
    private func request<T: Decodable & BaseResponse>(
        _ target: MyNetWorkService,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                self.logResponse(response)
                do {
                    let decodedData = try response.map(T.self)
                    
                    // Check if the response is successful using `isSuccess`
                    guard decodedData.isSuccess else {
                        let error = NetworkError.invalidResponse(decodedData.msg ?? "未知错误")
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success(decodedData))
                } catch {
                    print("JSON 解析失败：\(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("网络请求失败：\(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    // MARK: - 公共方法
    private func logResponse(_ response: Response) {
        guard isLoggingEnabled else { return }
        let responseString = String(data: response.data, encoding: .utf8) ?? "无效的响应"
        print("响应数据：\(responseString)")
    }
    
    // MARK: - API 请求封装
    func getUserDept(deptId: String,completion: @escaping (Result<DeptBean,Error>) -> Void){
        request(.getUserDept(deptId: deptId), type: DeptBean.self, completion: completion)
    }
    
    func getContact(completion: @escaping (Result<UserBean, Error>) -> Void) {
        request(.contact, type: UserBean.self, completion: completion)
    }
    
    func register(username: String, password: String, nickname: String, completion: @escaping (Result<LoginBean, Error>) -> Void) {
        request(.register(username: username, password: password, nickName: nickname), type: LoginBean.self, completion: completion)
    }
    
    func login(username: String, password: String, vercode: String, myuuid: String, completion: @escaping (Result<LoginBean, Error>) -> Void) {
        request(.login(username: username, password: password, vercode: vercode, myuuid: myuuid), type: LoginBean.self, completion: completion)
    }
    
    func getVerCode(completion: @escaping (Result<VerCodeBean, Error>) -> Void) {
        request(.verCode, type: VerCodeBean.self, completion: completion)
    }
    
    func getDeviceTypes(completion: @escaping (Result<DeviceType, Error>) -> Void) {
        request(.deviceType, type: DeviceType.self, completion: completion)
    }
    
    func getDeviceList(deviceId: String, pageNum: Int, pageSize: Int, completion: @escaping (Result<DeviceAllBean, Error>) -> Void) {
        request(.deviceInfo(deviceId: deviceId, pageNum: pageNum, pageSize: pageSize), type: DeviceAllBean.self, completion: completion)
    }
    
    func getDeviceData(deviceId: String, pageNum: Int, pageSize: Int, completion: @escaping (Result<DeviceDataBean, Error>) -> Void) {
        request(.deviceData(deviceId: deviceId, pageNum: pageNum, pageSize: pageSize), type: DeviceDataBean.self, completion: completion)
    }
    
    func getDevicePhoto(deviceId: String, completion: @escaping (Result<DeviceImageBean, Error>) -> Void) {
        request(.devicePhoto(deviceId: deviceId), type: DeviceImageBean.self, completion: completion)
    }
    
    func getDeviceChart(deviceId: String, completion: @escaping (Result<DeviceChartBean, Error>) -> Void) {
        request(.deviceChart(deviceId: deviceId), type: DeviceChartBean.self, completion: completion)
    } 
    func sporeControlInfo(deviceId: String, completion: @escaping (Result<SporeControlBean, Error>) -> Void) {
        request(.sporeControlInfo(deviceId: deviceId), type: SporeControlBean.self, completion: completion)
    }
    func getDeviceControl(deviceId: String,typecode:String, completion: @escaping (Result<DeviceControlBean, Error>) -> Void) {
        request(.deviceControl(deviceId: deviceId,typeCode: typecode), type: DeviceControlBean.self, completion: completion)
    }
    func getSendSpore(name: String,deviceId:String,value: Int, completion: @escaping (Result<DeviceType, Error>) -> Void) {
        request(.getSendSpore(name: name,deviceId: deviceId,value: value), type: DeviceType.self, completion: completion)
    }
    func uploadProfileImage(image: UIImage,  completion: @escaping (Result<DeviceType, Error>) -> Void) {
        request(.setProfileImage(image: image), type: DeviceType.self, completion: completion)
    }
}
