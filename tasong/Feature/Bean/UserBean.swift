//
//  UserBean.swift
//  tasong
//
//  Created by 贾杨 on 2024/10/22.
//

import Foundation

// 顶级结构体
struct UserBean: Identifiable, Codable, Hashable , BaseResponse {
    var id: String? { data?.userId.map { String($0) } }  // 从 data 中提取 id
    var postGroup: String?
    var roleGroup: String?
    var msg: String?
    var code: Int?
    var data: Contact?
}

// 用户详细信息
struct Contact: Identifiable, Codable, Hashable {
    var id: String? { String(userId ?? 0) } // userId 作为 id
    var createBy: String?
    var createTime: String?
    var updateBy: String?
    var updateTime: String? // updateTime 应该是 String，根据你的 JSON
    var userId: Int?
    var deptId: Int?
    var userName: String?
    var nickName: String?
    var email: String?
    var phonenumber: String?
    var sex: String?
    var avatar: String?
    var password: String?
    var status: String?
    var delFlag: String?
    var loginIp: String?
    var loginDate: String?
    var dept: Dept? // 部门信息
    var roles: [Role]? // 用户角色列表
    var roleIds: [Int]?
    var postIds: [Int]?
    var roleId: Int?
    var admin: Bool?
}

// 部门信息
struct Dept: Codable, Hashable {
    var deptId: Int?
    var parentId: Int?
    var deptName: String?
    var leader: String?
    var orderNum: Int?
    var status: String?
    var delFlag: String?
    var phone: String?
    var email: String?
    var children: [Dept]?
}

// 角色信息
struct Role: Codable, Hashable {
    var roleId: Int?
    var roleName: String?
    var roleKey: String?
    var roleSort: Int?
    var dataScope: String?
    var menuCheckStrictly: Bool?
    var deptCheckStrictly: Bool?
    var status: String?
    var delFlag: String?
    var admin: Bool?
}
