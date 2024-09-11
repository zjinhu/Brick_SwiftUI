
import SwiftUI
import PhotosUI
import Photos

public struct PhotoPicker<Label>: View where Label: View {
    @State private var isPresented: Bool = false
    @Binding var selected: [PHPickerResult]
    
    let filter: PHPickerFilter?
    let maxSelection: Int?
    let preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode
    let library: PHPhotoLibrary
    let label: Label
    
    public var body: some View {
        Button {
            isPresented = true
        } label: {
            label
        }
        ._photoPicker(
            isPresented: $isPresented,
            selected: $selected,
            filter: filter,
            maxSelectionCount: maxSelection,
            preferredAssetRepresentationMode: preferredAssetRepresentationMode,
            library: library
        )
    }
}


public extension PhotoPicker {
    
    init(
        selected: Binding<PHPickerResult?>,
        matching filter: PHPickerFilter? = nil,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic,
        @ViewBuilder label: () -> Label
    ) {
        _selected = .init(
            get: {
                [selected.wrappedValue].compactMap { $0 }
            },
            set: { newValue in
                selected.wrappedValue = newValue.first
            }
        )
        self.filter = filter
        self.maxSelection = 1
        self.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        self.library = .shared()
        self.label = label()
    }
}

public extension PhotoPicker {
    
    init(
        selected: Binding<PHPickerResult?>,
        matching filter: PHPickerFilter? = nil,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic,
        photoLibrary: PHPhotoLibrary,
        @ViewBuilder label: () -> Label
    ) {
        _selected = .init(
            get: {
                [selected.wrappedValue].compactMap { $0 }
            },
            set: { newValue in
                selected.wrappedValue = newValue.first
            }
        )
        self.filter = filter
        self.maxSelection = 1
        self.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        self.library = photoLibrary
        self.label = label()
    }
}

public extension PhotoPicker<Text> {
    
    init(
        _ titleKey: LocalizedStringKey,
        selected: Binding<PHPickerResult?>,
        matching filter: PHPickerFilter? = nil,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic
    ) {
        _selected = .init(
            get: {
                [selected.wrappedValue].compactMap { $0 }
            },
            set: { newValue in
                selected.wrappedValue = newValue.first
            }
        )
        self.filter = filter
        self.maxSelection = 1
        self.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        self.library = .shared()
        self.label = Text(titleKey)
    }
    
    init<S>(
        _ title: S,
        selected: Binding<PHPickerResult?>,
        matching filter: PHPickerFilter? = nil,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic
    ) where S: StringProtocol {
        _selected = .init(
            get: {
                [selected.wrappedValue].compactMap { $0 }
            },
            set: { newValue in
                selected.wrappedValue = newValue.first
            }
        )
        self.filter = filter
        self.maxSelection = 1
        self.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        self.library = .shared()
        self.label = Text(title)
    }
    
    init(
        _ titleKey: LocalizedStringKey,
        selected: Binding<PHPickerResult?>,
        matching filter: PHPickerFilter? = nil,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic,
        photoLibrary: PHPhotoLibrary
    ) {
        _selected = .init(
            get: {
                [selected.wrappedValue].compactMap { $0 }
            },
            set: { newValue in
                selected.wrappedValue = newValue.first
            }
        )
        self.filter = filter
        self.maxSelection = 1
        self.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        self.library = photoLibrary
        self.label = Text(titleKey)
    }
    
    init<S>(
        _ title: S,
        selected: Binding<PHPickerResult?>,
        matching filter: PHPickerFilter? = nil,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic,
        photoLibrary: PHPhotoLibrary
    ) where S: StringProtocol {
        _selected = .init(
            get: {
                [selected.wrappedValue].compactMap { $0 }
            },
            set: { newValue in
                selected.wrappedValue = newValue.first
            }
        )
        self.filter = filter
        self.maxSelection = 1
        self.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        self.library = photoLibrary
        self.label = Text(title)
    }
}

public extension PhotoPicker {
    
    init(
        selected: Binding<[PHPickerResult]>,
        maxSelectionCount: Int? = nil,
        matching filter: PHPickerFilter? = nil,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic,
        @ViewBuilder label: () -> Label
    ) {
        _selected = selected
        self.filter = filter
        self.maxSelection = maxSelectionCount
        self.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        self.library = .shared()
        self.label = label()
    }
    
    init(
        selected: Binding<[PHPickerResult]>,
        maxSelectionCount: Int? = nil,
        matching filter: PHPickerFilter? = nil,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic,
        photoLibrary: PHPhotoLibrary,
        @ViewBuilder label: () -> Label
    ) {
        _selected = selected
        self.filter = filter
        self.maxSelection = maxSelectionCount
        self.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        self.library = photoLibrary
        self.label = label()
    }
}

public extension PhotoPicker<Text> {
    
    init(
        _ titleKey: LocalizedStringKey,
        selected: Binding<[PHPickerResult]>,
        maxSelectionCount: Int? = nil,
        matching filter: PHPickerFilter? = nil,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic
    ) {
        _selected = selected
        self.filter = filter
        self.maxSelection = maxSelectionCount
        self.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        self.library = .shared()
        self.label = Text(titleKey)
    }
    
    init<S>(
        _ title: S,
        selected: Binding<[PHPickerResult]>,
        maxSelectionCount: Int? = nil,
        matching filter: PHPickerFilter? = nil,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic
    ) where S: StringProtocol {
        _selected = selected
        self.filter = filter
        self.maxSelection = maxSelectionCount
        
        self.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        self.library = .shared()
        self.label = Text(title)
    }
    
    init(
        _ titleKey: LocalizedStringKey,
        selected: Binding<[PHPickerResult]>,
        maxSelectionCount: Int? = nil,
        matching filter: PHPickerFilter? = nil,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic,
        photoLibrary: PHPhotoLibrary
    ) {
        _selected = selected
        self.filter = filter
        self.maxSelection = maxSelectionCount
        
        self.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        self.library = photoLibrary
        self.label = Text(titleKey)
    }
    
    init<S>(
        _ title: S,
        selected: Binding<[PHPickerResult]>,
        maxSelectionCount: Int? = nil,
        matching filter: PHPickerFilter? = nil,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic,
        photoLibrary: PHPhotoLibrary
    ) where S: StringProtocol {
        _selected = selected
        self.filter = filter
        self.maxSelection = maxSelectionCount
        
        self.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        self.library = photoLibrary
        self.label = Text(title)
    }
}

