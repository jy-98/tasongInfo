//
//  MePage.swift
//  mengchuang
//
//  Created by 贾杨 on 2024/10/15.
//

import SwiftUI
import UIKit

struct MePage: View {
    @StateObject var viewModel:MeVM
    @State private var isImagePickerPresented: Bool = false
       @State private var pickedImage: UIImage? = nil // 存储选择的图片
       @State private var showCamera = false // 控制是否使用相机
       @State private var showPicker = false // 控制图库选择器
    
    var body: some View {
        VStack(spacing: 0, content: {
            ToMeContent()
            MePageContent(viewModel:viewModel,userbean: viewModel.userbean, pickedImage: $pickedImage, isImagePickerPresented: $isImagePickerPresented, showCamera: $showCamera, showPicker: $showPicker)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // 使内容在 VStack 内上对齐
        .background(
            Image("center bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped() //如果图片比例与屏幕不匹配，这将防止图片超出边界
        )
        .ignoresSafeArea(.all) // 确保整个内容忽略安全区域
        .onAppear{
           viewModel.show()
       }
    }
}

struct ToMeContent:View {
    
    var body: some View {
        ZStack {
            Image("top bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: 107
                )
                .clipped()

        }
    }
}

struct MePageContent:View {
    @ObservedObject var viewModel: MeVM // 添加 @ObservedObject
    var userbean: UserBean
    @Binding var pickedImage: UIImage?
    @Binding var isImagePickerPresented: Bool
    @Binding var showCamera: Bool
    @Binding var showPicker: Bool
    var body: some View {
        
        VStack(spacing: 0){
            
            HStack(spacing: 0) {
                Button(action: {
                                    // 显示图片选择器
                                    let actionSheet = UIAlertController(title: "选择图片", message: nil, preferredStyle: .actionSheet)

                                    // 相机选项
                                    actionSheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: { _ in
                                        self.showCamera = true
                                    }))

                                    // 图片库选项
                                    actionSheet.addAction(UIAlertAction(title: "选择图库", style: .default, handler: { _ in
                                        self.showPicker = true
                                    }))
                                    
                                    // 取消
                                    actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))

                                    // 显示 actionSheet
                                    UIApplication.shared.windows.first?.rootViewController?.present(actionSheet, animated: true, completion: nil)
                                }) {
                                    // 展示AsyncImage或已选择的图片
                                    if let pickedImage = pickedImage {
                                        Image(uiImage: pickedImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 68, height: 68)
                                            .clipShape(Circle())
                                            .clipped()  // 避免图像超出圆形
                                    } else {
                                        if let encodedUrl = "\(Config.IPADDRESS)\(userbean.data?.avatar ?? "")"
                                            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                           let url = URL(string: encodedUrl) {
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .progressViewStyle(CircularProgressViewStyle())
                                                        .frame(width: 68, height: 68)
                                                        .foregroundColor(.blue)
                                                        .clipShape(Circle())
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 68, height: 68)
                                                        .clipShape(Circle())
                                                        .clipped()  // 避免图像超出圆形
                                                case .failure(_):
                                                    Image(systemName: "exclamationmark.triangle.fill")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 68, height: 68)
                                                        .foregroundColor(.red)
                                                        .clipShape(Circle())
                                                        .clipped()  // 避免图像超出圆形
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical, 34)
                                
                
                VStack(spacing: 0) {
                    Text(userbean.data?.userName ?? "")
                        .font(.system(size: 17))
                        .padding(.bottom, 18)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading) // 左对齐文本
                    
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("邮箱：")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                            .foregroundStyle(.secondary)
                        
                        Text(userbean.data?.email ?? "")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // 确保 HStack 左对齐
                }
                .padding(.leading, 10) // 控制 VStack 与图标之间的间距
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.horizontal,40)
            .background(Color.white) // 确保背景为白色，与边框颜色形成对比
            
            HStack() {
                Image("shouji")
                    .resizable() // 确保图像可调整大小
                    .scaledToFit() // 适应其容器
                    .frame(width: 20, height: 20) // 设置图标大小
                    .foregroundColor(.blue) // 图标颜色
                    .padding(.trailing, 14) // 图标与边框之间的内边距
                    .padding(.vertical,15)
                    .padding(.leading,30)
                
                Text("手机号码:")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                Text(userbean.data?.phonenumber ?? "")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(Color.white) // 确保背景为白色，与边框颜色形成对比
            .padding(.top,40)
            
            HStack() {
                Image("bumen")
                    .resizable() // 确保图像可调整大小
                    .scaledToFit() // 适应其容器
                    .frame(width: 20, height: 20) // 设置图标大小
                    .foregroundColor(.blue) // 图标颜色
                    .padding(.trailing, 14) // 图标与边框之间的内边距
                    .padding(.vertical,15)
                    .padding(.leading,30)
                
                Text("所属部门名称:")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                Text(userbean.postGroup ?? "")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(Color.white) // 确保背景为白色，与边框颜色形成对比
            .padding(.top,3)
            
            
            HStack() {
                Image("person")
                    .resizable() // 确保图像可调整大小
                    .scaledToFit() // 适应其容器
                    .frame(width: 20, height: 20) // 设置图标大小
                    .foregroundColor(.blue) // 图标颜色
                    .padding(.trailing, 14) // 图标与边框之间的内边距
                    .padding(.vertical,15)
                    .padding(.leading,30)
                
                Text("所属角色:")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                Text(userbean.data?.nickName ?? "")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(Color.white) // 确保背景为白色，与边框颜色形成对比
            .padding(.top,3)
            
            
            HStack() {
                Image("riqi")
                    .resizable() // 确保图像可调整大小
                    .scaledToFit() // 适应其容器
                    .frame(width: 20, height: 20) // 设置图标大小
                    .foregroundColor(.blue) // 图标颜色
                    .padding(.trailing, 14) // 图标与边框之间的内边距
                    .padding(.vertical,15)
                    .padding(.leading,30)
                
                Text("创建日期:")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                Text(userbean.data?.createTime ?? "")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(Color.white) // 确保背景为白色，与边框颜色形成对比
            .padding(.top,3)
            .padding(.bottom,205)
            
            
            HStack() {
                Button(action: {
                    // 清空保存的 token
                           UserDefaults.standard.removeObject(forKey: "authToken")
                           UserDefaults.standard.removeObject(forKey: "authUser")

                           // 执行退出登录的操作
                           AppState.shared.doFinishSplash()
                }, label: {
                    Text("退出登录")
                        .font(.system(size: 17))
                        .foregroundStyle(.red)
                        .padding(.vertical,15)
                })
                
                
            }
            .frame(maxWidth: .infinity,alignment: .center)
            .background(Color.white) // 确保背景为白色，与边框颜色形成对比
            
        }
        .sheet(isPresented: $showPicker, content: {
                   ImagePicker(sourceType: .photoLibrary) { selectedImage in
                       self.pickedImage = selectedImage // 更新选择的图片
                       if let deviceName = selectedImage {
                           viewModel.uploadImage(image: deviceName) // 上传图片
                       }

                   }
               })
               .sheet(isPresented: $showCamera, content: {
                   ImagePicker(sourceType: .camera) { selectedImage in
                       self.pickedImage = selectedImage // 更新拍摄的图片
                       if let deviceName = selectedImage {
                           viewModel.uploadImage(image: deviceName) // 上传图片
                       }
                   }
               })
        
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var didSelectImage: (UIImage?) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(didSelectImage: didSelectImage)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        imagePickerController.sourceType = sourceType
        return imagePickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var didSelectImage: (UIImage?) -> Void
        
        init(didSelectImage: @escaping (UIImage?) -> Void) {
            self.didSelectImage = didSelectImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                didSelectImage(image)
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            didSelectImage(nil)
            picker.dismiss(animated: true)
        }
    }
}

//#Preview {
//    MePage()
//}
