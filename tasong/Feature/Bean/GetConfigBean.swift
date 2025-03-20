//
//  GetConfigBean.swift
//  tasong
//
//  Created by 贾杨 on 2025/3/14.
//

import Foundation
struct GetConfigBean: Identifiable, Codable, Hashable , BaseResponse {
    var id: String?
    var code: Int?
    var data: Configs?
    var msg: String?
}

struct Configs: Identifiable,Codable, Hashable {
    var id: String?
    var data:[String]?
    var startTime:String = "0"
    var sensorTime:String = "0"
}


