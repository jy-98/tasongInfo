//
//  NetworkErrorHandler.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/23.
//

import Foundation

import Foundation

protocol NetworkErrorHandler {
    var errorMessage: String? { get set }

    func handleNetworkError(_ error: Error, completion: @escaping (String?) -> Void)
}

extension NetworkErrorHandler where Self: ObservableObject {
    func handleNetworkError(_ error: Error, completion: @escaping (String?) -> Void) {
        // 在这里处理不同类型的错误
        if let networkError = error as? NetworkError {
            let errorMessage: String
            switch networkError {
            case .invalidResponse(let msg),
                 .serverError(let msg):
                errorMessage = msg
            case .tokenMissing:
                errorMessage = "Token is missing."
            case .other(let underlyingError):
                errorMessage = underlyingError.localizedDescription
            }
            print("请求失败net: \(errorMessage)")
            completion(errorMessage) // 调用完成闭包返回错误消息
        } else {
            let errorMessage = error.localizedDescription
            print("请求失败lot: \(errorMessage)")
            completion(errorMessage) // 返回通用错误消息
        }
    }
}
