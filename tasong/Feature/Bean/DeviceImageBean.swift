//
//  DeviceImageBean.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/18.
//

import Foundation

struct DeviceImageBean: Identifiable, Codable, Hashable, BaseResponse  {
    var id: String?
    var code: Int?
    var `data`: [DataPhoto]?
    var msg: String?
}

struct DataPhoto: Identifiable, Codable, Hashable {
    var code: String?
    var createBy: String?
    var createTime: String?
    var createUser: String?
    var deviceId: String?
    var fileName: String?
    var fileNewName: String?
    var filePath: String?
    var fileUrl: String?
    var id: String?
    var originalFileName: String?
    var remark: String?
    var updateBy: String?
    var updateTime: String?
    var updateUser: String?
}
