//
//  ContactVM.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/22.
//

import Foundation

class ContactVM: BaseViewModel {
    
    @Published var userbean: UserBean // 存储验证码数据
    @Published var isLoginSuccessful: Bool = false  // 登录状态

    private let repository: MyNetWorkRepository // 数据仓库依赖
    
    // 初始化时加载数据
    init(repository: MyNetWorkRepository = .shared) {
        self.repository = repository
        self.userbean = UserBean()
        super.init()
    }
    
    func show(){
        repository.getContact{ [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let deviceType):
                    print("请求成功：\(String(describing: deviceType))")


                case .failure(let error):
                    self?.errorMessage = "请求失败: \(error.localizedDescription)"

                }
            }
        }
    }
    
    
}



