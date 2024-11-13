//
//  DeviceDataBean.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/18.
//

import Foundation
struct DeviceDataBean: Identifiable, Codable, Hashable , BaseResponse {
    var id: String?
    var code: Int?
    var msg: String?
    var rows: [Imei]?
    var total: Int?
}

struct Imei: Identifiable, Codable, Hashable {
    var id: String?
    var cmd: String?
    var `data`: String?
    var dataArray: [DataArray]?
    var deviceId: String?
    var index: String?
    var name: String?
    var sendTime: String?
    var unit: String?
    var value: String?
}

struct DataArray: Identifiable, Codable, Hashable {
    var index: Int?
    var name: String?
    var unit: String?
    var value: Double?
    var id: String {
          // 使用 index 和 name 的组合作为唯一 ID
          return "\(index ?? -1)-\(name ?? "")"
      }
}

