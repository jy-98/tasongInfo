//
//  DeviceControlBean.swift
//  tasong
//
//  Created by 贾杨 on 2024/11/4.
//

struct DeviceControlBean: Identifiable, Codable, Hashable,BaseResponse {
    var code: Int?
    
    var msg: String?
    
    var id: String?
    var data: [ControlBean]?
}
struct ControlBean: Identifiable, Codable, Hashable {
    var id: String {        // 使用 index 和 name 的组合作为唯一 ID
        return "\(type ?? "")"
    }  // 生成唯一字符串 ID
    var type: String?
    var value: Int?
    var key: String?
}

