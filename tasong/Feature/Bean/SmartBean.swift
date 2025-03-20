//
//  SmartBean.swift
//  tasong
//
//  Created by 贾杨 on 2025/3/4.
//

import Foundation
struct SmartBean: Identifiable, Codable, Hashable , BaseResponse {
    var id: String?
    var code: Int?
    var data: [SmartData]?
    var msg: String?
}



// 代表部门数据的结构
struct SmartData: Identifiable,Codable, Hashable {
    var id: String?
    var checked:Bool = false
//    var addressId: String?
    var children: [SmartData]?
    var name: String
//    var parentId: String?
//    var type: Int = 0
}

struct SmartDataBean{
    var id: String = UUID().uuidString // 默认使用 UUID
    var firstName: String?
    var addressName: String?
    var sensorName: String?
    var sensorCode: String?
}
