//
//  BaseViewModel.swift
//  所有VM父类
//
//  Created by 贾杨 on 2024/10/17.
//

import Foundation
class BaseViewModel:ObservableObject,NetworkErrorHandler{
    @Published var errorMessage: String? = nil  // 错误信息
}
