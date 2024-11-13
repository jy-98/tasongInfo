//
//  LoginVM.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/21.
//

import Foundation
import UIKit

class LoginVM: BaseViewModel {
    
    @Published var verCodeBean: VerCodeBean // 存储验证码数据
    @Published var loginBean: LoginBean // 存储验证码数据
    @Published var isLoginSuccessful: Bool = false  // 登录状态
    
    private let repository: MyNetWorkRepository // 数据仓库依赖
    
    // 初始化时加载数据
    init(repository: MyNetWorkRepository = .shared) {
        self.repository = repository
        self.verCodeBean = VerCodeBean()
        self.loginBean = LoginBean()
        super.init()
    }
    
    // 加载设备详细信息
      func loadData() {
          repository.getVerCode { [weak self] result in
              DispatchQueue.main.async {
                  switch result {
                  case .success(let deviceType):
                      print("验证码请求成功：\(String(describing: deviceType.img))")
                      self?.verCodeBean = deviceType
                  case .failure(let error):
                      self?.handleNetworkError(error) { errorMessage in
                          self?.errorMessage = errorMessage // 更新错误消息
                      }
                  }
              }
          }
      }
    
    func login(username: String, password: String, vercode: String, myuuid: String, completion: @escaping (Bool, String?) -> Void) {
//        repository.login(username: username, password: password, vercode: vercode, myuuid: myuuid) { [weak self] result in
        repository.login(username: "admin", password: "admin123", vercode: vercode, myuuid: myuuid) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let deviceType):
                    print("登陆请求成功：\(String(describing: deviceType))")
                    self?.loginBean = deviceType
                    if let token = deviceType.token {
                        UserDefaults.standard.set(token, forKey: "authToken")
                    }
                    self?.isLoginSuccessful = true
                    completion(true, nil) // 登录成功，返回 nil

                case .failure(let error):
                    // 调用基类方法处理错误，并获取具体的错误消息
                    self?.handleNetworkError(error) { errorMessage in
                        self?.errorMessage = errorMessage // 更新错误消息
                        completion(false, errorMessage) // 返回具体错误消息
                    }
                }
            }
        }
    }
}



