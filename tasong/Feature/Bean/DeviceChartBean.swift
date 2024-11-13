//
//  DeviceChartBean.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/18.
//

import Foundation

struct DeviceChartBean: Identifiable, Codable, Hashable, BaseResponse  {
    var msg: String?
    
    var id: String?
    var code: Int?
    var data: [DevChart]?
}

struct DevChart: Identifiable, Codable, Hashable {
   
    var name: String?
    var value: [String]?
    var id: String {        // 使用 index 和 name 的组合作为唯一 ID
        return "\(name ?? "")"
    }  // 生成唯一字符串 ID
}
