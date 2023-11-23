//
//  PhotoViewModel.swift
//  Capture
//
//  Created by Aye Chan on 2/22/23.
//

import SwiftUI
import Foundation
import Photos
#if os(iOS) || targetEnvironment(macCatalyst)
public class PhotoViewModel: ObservableObject {
    public let photoLibrary: PhotoLibraryService
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
    public func loadImage(targetSize: CGSize = PHImageManagerMaximumSize) async {
        do {
            let photo = try await photoLibrary.loadImage(for: assetId, targetSize: targetSize)
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
#endif
