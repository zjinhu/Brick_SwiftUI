//
//  File.swift
//  Brick_SwiftUI
//
//  Created by iOS on 9/11/24.
//

import SwiftUI
import PhotosUI
import Photos

public extension View {
    //System album selection of a single photo
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
    
    //System Album to select multiple photos
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
