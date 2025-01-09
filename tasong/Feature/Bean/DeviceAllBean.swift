//
//  DeviceAllBean.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/17.
//

import Foundation

struct DeviceAllBean: Identifiable, Codable, Hashable, BaseResponse  {
    var id: String?
    var code: Int?
    var msg: String?
    var data: [DeviceAll]?
    var total: Int?
}

struct DeviceAll: Identifiable, Codable, Hashable {
    var id: String?
    var cardNumber: String?
    var createBy: String?
    var createName: String?
    var createTime: String?
    var createUser: Int?
    var deviceId: String?
    var deviceName: String?
    var deviceTypeName: String?
    var fileName: String?
    var imei: String?
    var information: String?
    var isDelete: String?
    var isShow: String?
    var lat: Double?
    var longitude: Double?
    var pictureId: String?
    var remark: String?
    var typeCode: String?
    var updateBy: String?
    var updateName: String?
    var updateTime: String?
    var updateUser: Int?
    var isOnline: String?
}
