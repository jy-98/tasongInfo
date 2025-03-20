//
//  DeviceType.swift
//  设备类型
//
//  Created by 贾杨 on 2024/10/15.
//

import Foundation

struct DeviceType: Identifiable, Codable, Hashable , BaseResponse {
    var id: String?
    var code: Int?
    var msg: String?
    var rows: [DeType]?
    var total: Int?
}

struct DeType: Identifiable, Codable, Hashable {
    var id: String?
//    var createBy: String?
    var createName: String?
    var createTime: String?
//    var createUser: Int?
//    var deptId: String?
//    var image: String?
    var imageUrl: String?
//    var information: String?
//    var isDelete: Bool?
    var name: String?
//    var code_type: String?
//    var regionId: String?
//    var regionName: String?
//    var remark: String?
//    var updateBy: String?
//    var updateName: String?
//    var updateTime: String?
//    var updateUser: Int?
}

