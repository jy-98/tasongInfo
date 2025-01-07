//
//  NumericInputField.swift
//  tasong
//
//  Created by 贾杨 on 2025/1/7.
//

import SwiftUI

struct NumericInputField: View {
    let label: String
    @Binding var value: Int?  // 将绑定类型改为 Int?
    let minValue: Int
    let maxValue: Int
    let onSubmit: () -> Void  // 回调函数
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.black) // 控制项名称
            
            Spacer()
            
            // 输入框，限制为整数和负号
            TextField("0", text: Binding(
                get: {
                    // 将 Int? 转换为 String
                    value.map { String($0) } ?? ""
                },
                set: { newValue in
                    // 将 String 转换为 Int?
                    if let intValue = Int(newValue) {
                        // 只保留在范围内的值
                        value = min(max(intValue, minValue), maxValue)
                    } else {
                        value = nil  // 如果输入无效，设为 nil
                    }
                }
            ))
            .keyboardType(.default) // 使用数字和负号键盘
            .textFieldStyle(RoundedBorderTextFieldStyle()) // 给输入框加圆角
            .frame(width: 200) // 设置 TextField 宽度为最大
            .multilineTextAlignment(.center) // 居中文本
            .padding(.trailing, 8)
            .onSubmit {
                            // 当用户提交时，调用回调
                            onSubmit()
            }
        }
        .padding(16) // 增加上下内边距以增加行高
        .frame(height: 60) // 设置每行的高度
        .listRowBackground(Color.clear) // 设置每行的背景颜色为透明
    }
    
    func sendNetworkRequest() {
        // 根据需要实现发送网络请求的逻辑
        
    }
}
