#if os(iOS)
import SwiftUI
import PhotosUI

internal extension View {
    @ViewBuilder
    func _photoPicker(
        isPresented: Binding<Bool>,
        selection: Binding<[PHPickerResult]>,
        filter: PHPickerFilter?,
        maxSelectionCount: Int?,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode,
        library: PHPhotoLibrary
    ) -> some View {
        sheet(isPresented: isPresented) {
            PhotosViewController(
                isPresented: isPresented,
                selection: selection,
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
    @Binding var selection: [PHPickerResult]
    let configuration: PHPickerConfiguration
    
    init(isPresented: Binding<Bool>,
         selection: Binding<[PHPickerResult]>,
         filter: PHPickerFilter?,
         maxSelectionCount: Int?,
         preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode,
         library: PHPhotoLibrary) {
        _isPresented = isPresented
        _selection = selection
        
        var configuration = PHPickerConfiguration(photoLibrary: library)
        configuration.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        configuration.selectionLimit = maxSelectionCount ?? 0
        configuration.filter = filter
 
        self.configuration = configuration
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, selection: $selection, configuration: configuration)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator.controller
    }
    
    func updateUIViewController(_ controller: UIViewController, context: Context) {
        context.coordinator.isPresented = $isPresented
        context.coordinator.selection = $selection
        context.coordinator.configuration = configuration
    }
}


private extension PhotosViewController {
    final class Coordinator: NSObject, PHPickerViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
        var isPresented: Binding<Bool>
        var selection: Binding<[PHPickerResult]>
        var configuration: PHPickerConfiguration
        
        lazy var controller: PHPickerViewController = {
            let controller = PHPickerViewController(configuration: configuration)
            controller.presentationController?.delegate = self
            controller.delegate = self
            return controller
        }()
        
        init(isPresented: Binding<Bool>, selection: Binding<[PHPickerResult]>, configuration: PHPickerConfiguration) {
            self.isPresented = isPresented
            self.selection = selection
            self.configuration = configuration
            super.init()
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            isPresented.wrappedValue = false
            selection.wrappedValue = results
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            isPresented.wrappedValue = false
        }
    }
}

#endif
