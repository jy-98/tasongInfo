//
//  MeVM.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/22.
//

import Foundation
import UIKit

class MeVM: BaseViewModel {
    
    @Published var userbean: UserBean
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
                    UserDefaults.standard.set(deviceType.data?.userId, forKey: "authUser")
                    UserDefaults.standard.set(deviceType.data?.deptId, forKey: "deptId")
                    self?.userbean = deviceType

                case .failure(let error):
                    self?.errorMessage = "请求失败: \(error.localizedDescription)"

                }
            }
        }
    }
    
    func uploadImage(image: UIImage) {
        // 使用 repository 的方法进行图片上传
        repository.uploadProfileImage(image: image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // 假设 response 是一个上传成功后的返回数据
                    print("图片上传成功: \(response)")
//                    self?.successMessage = "图片上传成功！"

                case .failure(let error):
                    self?.errorMessage = "上传失败: \(error.localizedDescription)"
                }
            }
        }
    }

    
}
