
import SwiftUI
import PhotosUI
import Photos
import UIKit

internal extension View {
    @ViewBuilder
    func _photoPicker(
        isPresented: Binding<Bool>,
        selected: Binding<[PHPickerResult]>,
        filter: PHPickerFilter?,
        maxSelectionCount: Int?,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode,
        library: PHPhotoLibrary
    ) -> some View {
        sheet(isPresented: isPresented) {
            PhotosViewController(
                isPresented: isPresented,
                selected: selected,
                filter: filter,
                maxSelectionCount: maxSelectionCount,
                preferredAssetRepresentationMode: preferredAssetRepresentationMode,
                library: library
            )
            .ignoresSafeArea()
        }
        
    }
}

private struct PhotosViewController: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selected: [PHPickerResult]
    private var selectedAssetIdentifiers = [String]()
    let configuration: PHPickerConfiguration
    
    init(isPresented: Binding<Bool>,
         selected: Binding<[PHPickerResult]>,
         filter: PHPickerFilter?,
         maxSelectionCount: Int?,
         preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode,
         library: PHPhotoLibrary) {
        _isPresented = isPresented
        _selected = selected

        selectedAssetIdentifiers = selected.wrappedValue.map(\.assetIdentifier!)

        var configuration = PHPickerConfiguration(photoLibrary: library)
        configuration.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        configuration.selectionLimit = maxSelectionCount ?? 1
        configuration.filter = filter
        if #available(iOS 15.0, *) {
            configuration.selection = .ordered
            configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers
        } else {

        }
        self.configuration = configuration
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, 
                    selection: $selected,
                    configuration: configuration)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator.controller
    }
    
    func updateUIViewController(_ controller: UIViewController, context: Context) {
        context.coordinator.isPresented = $isPresented
        context.coordinator.selected = $selected
        context.coordinator.configuration = configuration
    }
}


private extension PhotosViewController {
    final class Coordinator: NSObject, PHPickerViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
        
        var isPresented: Binding<Bool>
        var selected: Binding<[PHPickerResult]>
        var configuration: PHPickerConfiguration

        lazy var controller: PHPickerViewController = {
            let controller = PHPickerViewController(configuration: configuration)
            controller.presentationController?.delegate = self
            controller.delegate = self
            return controller
        }()
        
        init(isPresented: Binding<Bool>, 
             selection: Binding<[PHPickerResult]>,
             configuration: PHPickerConfiguration) {
            self.isPresented = isPresented
            self.selected = selection
            self.configuration = configuration
            super.init()
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            isPresented.wrappedValue = false
            selected.wrappedValue = results
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            isPresented.wrappedValue = false
        }
    }
}
