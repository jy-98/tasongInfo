//
//  LoginBean.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/21.
//

import Foundation

struct LoginBean: Identifiable, Codable, Hashable , BaseResponse {
    var code: Int?
    
    var id: String?
    var msg: String?
    var token: String?
}
