//
//  BottomSheetView.swift
//  tasong
//
//  Created by 贾杨 on 2025/3/5.
//

import SwiftUI

struct BottomSheetView: View {
    let data: [SmartData] // 省级数据

    @Binding var selectedProvince: SmartData?
    @Binding var selectedCity: SmartData?
    @Binding var selectedDistrict: SmartData?
    @Binding var showSheet: Bool

    var onConfirm: (SmartData?, SmartData?, SmartData?) -> Void // ✅ 回调函数
    // 是否所有选择项都已经选择
       private var isValidSelection: Bool {
           selectedProvince != nil && selectedCity != nil && selectedDistrict != nil
       }
    var body: some View {
        VStack {
            Text("选择配置")
                .foregroundColor(.black)
                .font(.headline)
                .padding()

            HStack(spacing: 0) {
                // **省级列表**
                ScrollView {
                    LazyVStack {
                        ForEach(data, id: \.id) { province in
                            Button(action: {
                                selectedProvince = province
                                selectedCity = nil
                                selectedDistrict = nil
                            }) {
                                Text(province.name ?? "未知")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedProvince?.id == province.id ? Color.blue.opacity(0.3) : Color.clear)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1))

                // **市级列表**
                ScrollView {
                    LazyVStack {
                        ForEach(selectedProvince?.children ?? [], id: \.id) { city in
                            Button(action: {
                                selectedCity = city
                                selectedDistrict = nil
                            }) {
                                Text(city.name ?? "未知")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedCity?.id == city.id ? Color.blue.opacity(0.3) : Color.clear)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1))

                // **区县列表**
                ScrollView {
                    LazyVStack {
                        ForEach(selectedCity?.children ?? [], id: \.id) { district in
                            Button(action: {
                                selectedDistrict = district
                            }) {
                                Text(district.name ?? "未知")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedDistrict?.id == district.id ? Color.blue.opacity(0.3) : Color.clear)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1))
            }
            // 选择不完整时提示用户
                       if !isValidSelection {
                           Text("请选择传感器配置数据")
                               .foregroundColor(.red)
                               .font(.subheadline)
                               .padding()
                       }
            // ✅ 确定按钮
            HStack{
                Button("取消") {
                    withAnimation {
                        showSheet = false // 关闭弹框
                    }
                }
                .buttonStyle(.bordered)
                .foregroundColor(.white)
                .cornerRadius(10)
                Button("确定") {
                    withAnimation {
                        if isValidSelection {
                                                   onConfirm(selectedProvince, selectedCity, selectedDistrict) // ✅ 调用回调
                                                   showSheet = false // 关闭弹框
                                               } else {
                                                   // 提示用户必须选择完整
                                               }
                    }
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(!isValidSelection) // 禁用未选择完整时的确认按钮

            }
        }
    }
}


//struct BottomSheetView: View {
//    let data: [SmartData] // 省级数据
//
//    @Binding var selectedProvince: SmartData?
//    @Binding var selectedCity: SmartData?
//    @Binding var selectedDistrict: SmartData?
//    @Binding var showSheet: Bool
//
//    var body: some View {
//        VStack {
//            Text("选择配置")
//                .foregroundColor(.black)
//                .font(.headline)
//                .padding()
//
//            HStack(spacing: 0) {
//                // **省级列表**
//                ScrollView {
//                    LazyVStack {
//                        ForEach(data, id: \.id) { province in
//                            Button(action: {
//                                selectedProvince = province
//                                selectedCity = nil
//                                selectedDistrict = nil
//                            }) {
//                                Text(province.name ?? "未知")
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .background(selectedProvince?.id == province.id ? Color.blue.opacity(0.3) : Color.clear)
//                                    .cornerRadius(5)
//                            }
//                        }
//                    }
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.gray.opacity(0.1))
//	
//                // **市级列表**
//                ScrollView {
//                    LazyVStack {
//                        ForEach(selectedProvince?.children ?? [], id: \.id) { city in
//                            Button(action: {
//                                selectedCity = city
//                                selectedDistrict = nil
//                            }) {
//                                Text(city.name ?? "未知")
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .background(selectedCity?.id == city.id ? Color.blue.opacity(0.3) : Color.clear)
//                                    .cornerRadius(5)
//                            }
//                        }
//                    }
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.gray.opacity(0.1))
//
//                // **区县列表**
//                ScrollView {
//                    LazyVStack {
//                        ForEach(selectedCity?.children ?? [], id: \.id) { district in
//                            Button(action: {
//                                selectedDistrict = district
//                            }) {
//                                Text(district.name ?? "未知")
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .background(selectedDistrict?.id == district.id ? Color.blue.opacity(0.3) : Color.clear)
//                                    .cornerRadius(5)
//                            }
//                        }
//                    }
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.gray.opacity(0.1))
//            }
//        }
//        .onAppear {
//                   // 每次弹框打开时，清空选中的省、市、区
//                   selectedProvince = nil
//                   selectedCity = nil
//                   selectedDistrict = nil
//               }
//
//    }
//}
