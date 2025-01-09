//
//  ImagePicker.swift
//  tasong
//
//  Created by 贾杨 on 2025/1/9.
//

import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @Binding var pickedImage: UIImage?

    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            maxSelectionCount: 1,
            matching: .images) {
                Text("选择图片")
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    // Retrieve selected asset
                    guard let selectedItem else { return }

                    // Retrieve selected asset in the form of Data
                    if let data = try? await selectedItem.loadTransferable(type: Data.self) {
                        selectedImageData = data
                        if let imageData = selectedImageData {
                            pickedImage = UIImage(data: imageData)
                        }
                    }
                }
            }

        // 其他UI布局...
    }
}
