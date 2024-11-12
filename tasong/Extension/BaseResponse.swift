//
//  BaseResponse.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/23.
//

import Foundation
protocol BaseResponse: Decodable {
    var code: Int? { get }
    var msg: String? { get }
}

extension BaseResponse {
    var isSuccess: Bool {
        return code == 200
    }
}
