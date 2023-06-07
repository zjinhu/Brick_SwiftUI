//
//  PhotoPickerView.swift
//  Example
//
//  Created by iOS on 2023/6/7.
//

import SwiftUI
import Brick_SwiftUI
import PhotosUI
struct PhotoPickerView: View {
    @State private var selectedItem: Brick<Any>.PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    @State private var photoData: Data?
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack{
            Button {
                isPresented.toggle()
            } label: {
                Text("Camera")
            }
            .fullScreenCover(isPresented: $isPresented) {
                CameraView(photoData: $photoData)
            }

            Brick.PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Text("Select a photo")
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        // Retrieve selected asset in the form of Data
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
            
            if let photoData,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView()
    }
}
