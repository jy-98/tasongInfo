//
//  VerCodeBean.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/21.
//

import Foundation
struct VerCodeBean: Identifiable, Codable, Hashable , BaseResponse {
    var id: String?
    var code: Int?
    var msg: String?
    var img: String?
    var uuid: String?
    var captchaEnabled: Bool?
}
