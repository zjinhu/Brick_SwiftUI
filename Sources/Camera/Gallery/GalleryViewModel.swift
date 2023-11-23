//
//  GalleryViewModel.swift
//  Capture
//
//  Created by Aye Chan on 2/21/23.
//

import Photos
import SwiftUI
import Foundation
import Combine
#if os(iOS) || targetEnvironment(macCatalyst)
public class GalleryViewModel: ObservableObject {
    private let photoLibrary: PhotoLibraryService
    private var subscribers: [AnyCancellable] = []
    
    public init(photoLibrary: PhotoLibraryService) {
        self.photoLibrary = photoLibrary
        
        photoLibrary.$photoLibraryChange
            .receive(on: DispatchQueue.main)
            .sink { change in
                self.bindLibraryUpdate(change: change)
            }
            .store(in: &subscribers)
    }
    
    @Published public var results = PHFetchResult<PHAsset>()
}

extension GalleryViewModel {
    func bindLibraryUpdate(change: PHChange?) {
        if let changes = change?.changeDetails(for: results) {
            withAnimation {
                results = changes.fetchResultAfterChanges
            }
        }
    }
}

extension GalleryViewModel {
    public func loadImage(for assetId: String, targetSize: CGSize) async -> UIImage? {
        try? await photoLibrary.loadImage(for: assetId, targetSize: targetSize)
    }
    
    public func loadAllPhotos() async {
        let results = await photoLibrary.fetchAllPhotos()
        await MainActor.run {
            withAnimation {
                self.results = results
            }
        }
    }
}
#endif
