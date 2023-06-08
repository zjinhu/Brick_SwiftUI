//
//  PhotoPickerView.swift
//  Example
//
//  Created by iOS on 2023/6/7.
//
import UIKit
import SwiftUI
import PhotosUI
import Brick_SwiftUI
struct PhotoPickerView: View {
    @State private var selectedItem: PHPickerResult?
    @State private var selectedImage: UIImage?
    
    @State private var photoData: Data?
    
    @State private var isPresented: Bool = false
    @State private var showPicker: Bool = false
    
    var body: some View {
        List{
            Button {
                isPresented.toggle()
            } label: {
                Text("Camera")
            }
            .fullScreenCover(isPresented: $isPresented) {
                CameraView(photoData: $photoData)
            }

            Button {
                showPicker.toggle()
            } label: {
                Text("Show Picker 1")
            }
            .ss.photosPicker(isPresented: $showPicker,
                             selection: $selectedItem,
                             matching: .any(of: [.images]))

            PhotoPicker("Show Picker 2", selection: $selectedItem)
            
            if let selectedImage {
                Image(uiImage: selectedImage)
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
        .onChange(of: selectedItem) { newItem in
            Task{
                selectedImage = try? await newItem?.loadTransferable(type: UIImage.self)
            }
        }
        
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView()
    }
}
