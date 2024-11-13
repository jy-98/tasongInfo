//
//  MyNetWorkService.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/16.
//

import Foundation
import Moya

enum MyNetWorkService{
    case register(username: String, password: String,nickName:String)
    case login(username: String, password: String,vercode: String,myuuid: String)
    case deviceType
    case verCode
    case contact
    case deviceInfo(deviceId:String,pageNum:Int,pageSize:Int)
    case deviceData(deviceId:String)
    case devicePhoto(deviceId:String)
    case deviceChart(deviceId:String)
    case deviceControl(deviceId:String,typeCode: String)
}

extension MyNetWorkService:TargetType{
    var baseURL: URL {
        return URL(string: Config.IPADDRESS)!
    }
    
    var path: String {
        switch self {
        case .register:
            return "\(Config.relase)/system/user"
//            return "dev-api/system/user"
        case .login:
            return "\(Config.relase)/login"
//            return "dev-api/login"
        case .deviceType:
            return "\(Config.relase)/system/device/list"
//            return "dev-api/system/device/list"
        case .deviceInfo:
            return "\(Config.relase)/system/specific/getSpecificByDevice"
//            return "dev-api/system/specific/getSpecificByDevice"
        case .deviceData:
            return "\(Config.relase)/system/mqtt/device/data"
//            return "dev-api/system/mqtt/device/data"
        case .devicePhoto:
            return "\(Config.relase)/system/mqtt/device/image/info"
//            return "dev-api/system/mqtt/device/image/info"
        case .deviceChart:
            return "\(Config.relase)/system/mqtt/device/statistics"
//            return "dev-api/system/mqtt/device/statistics"
        case .verCode:
            return "\(Config.relase)/captchaImage"
//            return "dev-api/captchaImage"
        case .contact:
            return "\(Config.relase)/system/user/profile"
//            return "dev-api/system/user/profile"
        case .deviceControl:
            return "\(Config.relase)/system/mqtt/device/testLight/status"
//            return "dev-api/system/mqtt/device/testLight/status"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .deviceType, .deviceInfo, .deviceData, .devicePhoto, .deviceChart, .verCode , .contact,.deviceControl:
            return .get
        case .register, .login:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .register(username, password,nickName):
            // 注册时传递用户名和密码作为请求体
            let parameters: [String: Any] = [
                "username": username,
                "password": password,
                "nickName": nickName
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .login(username, password, vercode, myuuid):
            // 登陆时传递用户名和密码作为请求体
            let parameters: [String: Any] = [
                "username": username,
                "password": password,
                "code": vercode,
                "uuid": myuuid
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .deviceType:
            return .requestPlain
        case .contact:
            return .requestPlain
        case .verCode:
            return .requestPlain
        case let .deviceInfo(deviceId,pageNum,pageSize):
            // 将 GET 请求的参数放到查询字符串中
            return .requestParameters(parameters: [
                "deviceId": deviceId,
                "pageNum": pageNum,
                "pageSize": pageSize
            ], encoding: URLEncoding.queryString)
        case .deviceData(deviceId: let deviceId):
            return .requestParameters(parameters: [
                "deviceId": deviceId,
            ], encoding: URLEncoding.queryString)
        case .devicePhoto(deviceId: let deviceId):
            return .requestParameters(parameters: [
                "deviceId": deviceId,
            ], encoding: URLEncoding.queryString)
        case .deviceChart(deviceId: let deviceId):
            return .requestParameters(parameters: [
                "deviceId": deviceId,
            ], encoding: URLEncoding.queryString)
        case .deviceControl(deviceId: let deviceId, typeCode: let typeCode):
            return .requestParameters(parameters: [
                "deviceId": deviceId,
                "typeCode": typeCode,
            ], encoding: URLEncoding.queryString)
        }
        
    }
    
    var headers: [String : String]? {
        var headers:Dictionary<String,String> = [:]
        
        //如果本地存在 token，则将其添加到请求头部
        // Retrieve token from UserDefaults
        if let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty {
            headers["Authorization"] = "Bearer \(token)"
        } else {
            // If token is missing or empty, navigate to LoginPage
            print("Token is missing. Redirecting to login...")
            redirectToLogin() // Handle navigation to login
        }
        //        headers["Authorization"] = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJsb2dpbl91c2VyX2tleSI6Ijk0YWU3MGQ3LTRhNGYtNDE5NC1iNzVlLTNmNzQxMzYwZWY2YyJ9.pk_1eRmhv9Muhvb-Jwqwep6vFVx9vsx2prUblQ_3YE-u1Z_a_E4JQmoJ6ucro9SzOS47Te37bOsVwp4B72lG3Q"
        // 设置通用的 Content-Type
        headers["Content-Type"] = "application/json"
        return headers
    }
    
    //回到首页
    func redirectToLogin(){
        AppState.shared.doFinishSplash()
    }
}