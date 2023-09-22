//
//  PhotoViewModel.swift
//  Capture
//
//  Created by Aye Chan on 2/22/23.
//

import SwiftUI
import Foundation

class PhotoViewModel: ObservableObject {
    let photoLibrary: PhotoLibraryService
    let assetId: String
    
    @Published var photo: UIImage?
    @Published var scale: CGFloat = 1.0
    @Published var lastScale: CGFloat = 1.0
    @Published var offset: CGSize = .zero
    @Published var lastOffset: CGSize = .zero
    @Published var photoLibraryError: PhotoLibraryError?
    
    public init(assetId: String,
                photoLibrary: PhotoLibraryService) {
        self.photoLibrary = photoLibrary
        self.assetId = assetId
    }
}

// MARK: - Fetching
extension PhotoViewModel {
    func loadImage(targetSize: CGSize) async {
        do {
            let size = CGSize(width: targetSize.width * 3, height: targetSize.height * 3)
            let photo = try await photoLibrary.loadImage(for: assetId, targetSize: size)
            await MainActor.run {
                self.photo = photo
            }
        } catch {
            await MainActor.run {
                photoLibraryError = error as? PhotoLibraryError ?? .photoLoadingFailed
            }
        }
    }
}
