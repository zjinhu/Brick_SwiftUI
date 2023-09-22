//
//  PhotoViewModel.swift
//  Capture
//
//  Created by Aye Chan on 2/22/23.
//

import SwiftUI
import Foundation

public class PhotoViewModel: ObservableObject {
    private let photoLibrary: PhotoLibraryService
    private let assetId: String
    
    @Published public var photo: UIImage?
    @Published public var scale: CGFloat = 1.0
    @Published public var lastScale: CGFloat = 1.0
    @Published public var offset: CGSize = .zero
    @Published public var lastOffset: CGSize = .zero
    @Published public var photoLibraryError: PhotoLibraryError?
    
    public init(assetId: String,
                photoLibrary: PhotoLibraryService) {
        self.photoLibrary = photoLibrary
        self.assetId = assetId
    }
}

// MARK: - Fetching
extension PhotoViewModel {
    public func loadImage(targetSize: CGSize) async {
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
