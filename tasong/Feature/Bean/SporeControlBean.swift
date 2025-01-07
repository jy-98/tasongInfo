//
//  SporeControlBean.swift
//  tasong
//
//  Created by 贾杨 on 2025/1/7.
//

import Foundation
struct SporeControlBean: Identifiable, Codable, Hashable , BaseResponse {
    var id: String?
    var code: Int?
    var data: SporeControlData?
    var msg: String?
}



struct SporeControlData: Identifiable,Codable, Hashable {
    var id: String?
    var fan1: Int?
    var capture: Int?
    var restart: Int?
    var light1: Int?
    var heater: Int?
    var motor1: Int?
    var motor2: Int?
    var motor3: Int?
}
