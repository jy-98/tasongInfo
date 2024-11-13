//
//  VerCodeError.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/23.
//

import Foundation
// 定义一个自定义错误类型
enum NetworkError: Error {
    case invalidResponse(String)
    case tokenMissing
    case serverError(String)
    case other(Error)

    var localizedDescription: String {
        switch self {
        case .invalidResponse(let message),
             .serverError(let message):
            return message
        case .tokenMissing:
            return "Token is missing."
        case .other(let error):
            return error.localizedDescription
        }
    }
}

