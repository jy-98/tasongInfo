//
//  ContactVM.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/22.
//

import Foundation

class ContactVM: BaseViewModel {
    
    @Published var deptBean: DeptBean

    private let repository: MyNetWorkRepository // 数据仓库依赖
    
    // 初始化时加载数据
    init(repository: MyNetWorkRepository = .shared) {
        self.repository = repository
        self.deptBean = DeptBean()
        super.init()
    }
    
    func show() {
        if let user = UserDefaults.standard.string(forKey: "deptId"), !user.isEmpty {
            repository.getUserDept(deptId: user) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let deptBean):
                        print("请求公司信息成功：\(String(describing: deptBean))")
                        self?.deptBean = deptBean  // 更新 deptBean
                    case .failure(let error):
                        self?.errorMessage = "请求失败: \(error.localizedDescription)"
                    }
                }
            }
        }
    }

    
    
    
}



