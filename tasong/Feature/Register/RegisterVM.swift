//
//  RegisterVM.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/22.
//

import Foundation

class RegisterVM: BaseViewModel {
    
//    @Published var loginBean: LoginBean // 注册数据

    private let repository: MyNetWorkRepository // 数据仓库依赖
    
    // 初始化时加载数据
    init(repository: MyNetWorkRepository = .shared) {
        self.repository = repository
//        self.loginBean = LoginBean()
        super.init()
    }
    
    func generateRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in letters.randomElement() })
    }

    func getRegister(username: String, password: String, nickname: String? = nil) {
        // 如果 nickname 为 nil，生成一个随机字符串
        let finalNickname = nickname ?? generateRandomString(length: 5)
        
        repository.register(username: username, password: password, nickname: finalNickname) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let deviceType):
                    print("注册请求成功：\(String(describing: deviceType))")
//                    self?.loginBean = deviceType
                case .failure(let error):
                    self?.errorMessage = "注册请求失败: \(error.localizedDescription)"
                }
            }
        }
    }
}
