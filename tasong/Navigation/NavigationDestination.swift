//
//  NavigationDestination.swift
//  项目路由
//
//  Created by 贾杨 on 2024/10/17.
//

import Foundation

enum NavigationDestination:Hashable{
    
    //设备列表
    case deviceDetail(deviceId:String,name :String)
    
    //设备数据
    case deviceData(deviceId:String)
    
    //设备控制
    case deviceControl(deviceId:String,typeCode:String)

    //设备统计
    case deviceStat(deviceId:String)

    //设备图像
    case devicePhoto(deviceId:String)
    
    //账号注册
    case register

}
