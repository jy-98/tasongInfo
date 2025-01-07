//
//  DeptBean.swift
//  tasong
//
//  Created by 贾杨 on 2025/1/7.
//

import Foundation
import Foundation

// 代表返回的整体数据结构
struct DeptBean: Identifiable, Codable, Hashable , BaseResponse {
    var id: String?
    var code: Int?
    var data: DeptData?
    var msg: String?
}



// 代表部门数据的结构
struct DeptData: Identifiable,Codable, Hashable {
    var id: String?
    var ancestors: String?
    var children: [String]?
    var createBy: String?
    var createTime: String?
    var delFlag: String?
    var deptId: Int?
    var deptName: String?
    var email: String?
    var leader: String?
    var orderNum: Int?
    var parentId: Int?
    var parentName: String?
    var phone: String?
    var remark: String?
    var deptAddress: String?
    var website: String?
    var status: String?
    var updateBy: String?
    var updateTime: String?
}
