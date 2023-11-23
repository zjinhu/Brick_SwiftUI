//
//  PhotoPickerView.swift
//  Example
//
//  Created by iOS on 2023/6/7.
//
import SwiftUI
import PhotosUI
import BrickKit
import CameraKit
#if os(iOS)
import UIKit

struct PhotoPickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedItem: PHPickerResult?
    @State private var selectedImage: UIImage?
    
    @State private var selectedItem2: PHPickerResult?
    @State private var selectedImage2: UIImage?
    
    @State private var photoData: Data?
    
    @State private var isPresented: Bool = false
    @State private var showPicker: Bool = false

    @State var data: Data?
    
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
            .photosPicker(isPresented: $showPicker,
                             selection: $selectedItem,
                             matching: .any(of: [.images]))
            .onChange(of: selectedItem) { newItem in
                Task{
                    selectedImage = try? await newItem?.loadTransfer(type: UIImage.self)
                }
            }
            
            PhotoPicker("Show Picker 2", selection: $selectedItem2)
                .onChange(of: selectedItem2) { newItem in
                    newItem?.loadTransfer(type: UIImage.self, completion: { result in
                        switch result {
                        case .success(let image):
                            if let image = image {
                                selectedImage2 = image
                            } else {
                                print("Found nil in data")
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    })
                }
            
//            PhotosPicker(selection: $selected, maxSelectionCount: 1, matching: .images) {
//                HStack {
//                    Image(systemName: "photo")
//                        .resizable()
//                        .frame(width: 60, height: 45, alignment: .center)
//                    Text("Select a photo")
//                }
//            }
//            .onChange(of: selected) { newValue in
//                guard let selectedItem = selected.first else {
//                    return
//                }
//                selectedItem.loadTransferable(type: Data.self) { result in
//                    switch result {
//                    case .success(let data):
//                        if let data = data {
//                            self.data = data
//                        } else {
//                            print("Found nil in data")
//                        }
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
//            }
            
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
            
            if let selectedImage2 {
                Image(uiImage: selectedImage2)
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
            
            if let data = data, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            }
        }
        .ss.tabBar(.hidden)
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                }
            }
        }
        
    }
}
 
struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView()
    }
}
#endif
