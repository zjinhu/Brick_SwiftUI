//
//  File.swift
//  Brick_SwiftUI
//
//  Created by iOS on 9/11/24.
//
#if os(iOS)
import SwiftUI
import PhotosUI
import Photos

public extension View {

    func photoPicker(
        isPresented: Binding<Bool>,
        selected: Binding<PHPickerResult?>,
        matching filter: PHPickerFilter? = nil,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic,
        photoLibrary: PHPhotoLibrary = .shared()
    ) -> some View {
        let binding = Binding(
            get: {
                [selected.wrappedValue].compactMap { $0 }
            },
            set: { newValue in
                selected.wrappedValue = newValue.first
            }
        )
        return photoPicker(
            isPresented: isPresented,
            selected: binding,
            maxSelectionCount: 1,
            matching: filter,
            preferredAssetRepresentationMode: preferredAssetRepresentationMode,
            photoLibrary: photoLibrary
        )
    }
    
    ///You need to obtain permissions for albums before opening them
    ///打开相册之前需要获取相册权限
    func photoPicker(
        isPresented: Binding<Bool>,
        selected: Binding<[PHPickerResult]>,
        maxSelectionCount: Int? = nil,
        matching filter: PHPickerFilter? = nil,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic,
        photoLibrary: PHPhotoLibrary = .shared()
    ) -> some View {
        _photoPicker(
            isPresented: isPresented,
            selected: selected,
            filter: filter,
            maxSelectionCount: maxSelectionCount,
            preferredAssetRepresentationMode: preferredAssetRepresentationMode,
            library: photoLibrary
        )
    }
}
#endif
