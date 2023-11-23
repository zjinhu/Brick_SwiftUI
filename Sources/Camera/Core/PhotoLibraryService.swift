//
//  File.swift
//  
//
//  Created by 狄烨 on 2023/9/21.
//

import Foundation
import Photos
import Combine
#if os(iOS) || targetEnvironment(macCatalyst)
import UIKit
public class PhotoLibraryService: NSObject {
    let photoLibrary: PHPhotoLibrary
    let imageCachingManager = PHCachingImageManager()

    @Published var photoLibraryChange : PHChange?
    
    public override init() {
        self.photoLibrary = .shared()
        super.init()
        self.photoLibrary.register(self)
    }
}

public extension PhotoLibraryService {
    func fetchAllPhotos() async -> PHFetchResult<PHAsset> {
        await withCheckedContinuation { (continuation: CheckedContinuation<PHFetchResult<PHAsset>, Never>) in
            imageCachingManager.allowsCachingHighQualityImages = false
            let fetchOptions = PHFetchOptions()
            fetchOptions.includeHiddenAssets = false
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            continuation.resume(returning: PHAsset.fetchAssets(with: .image, options: fetchOptions))
        }
    }

    func loadImage(for localId: String, targetSize: CGSize = PHImageManagerMaximumSize, contentMode: PHImageContentMode = .default) async throws -> UIImage? {
        let results = PHAsset.fetchAssets(
            withLocalIdentifiers: [localId],
            options: nil
        )
        guard let asset = results.firstObject else {
            throw PhotoLibraryError.photoNotFound
        }
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        return try await withCheckedThrowingContinuation { [unowned self] continuation in
            imageCachingManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: contentMode,
                options: options,
                resultHandler: { image, info in
                    if let error = info?[PHImageErrorKey] as? Error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume(returning: image)
                }
            )
        }
    }
}

public extension PhotoLibraryService {
    func savePhoto(for photoData: Data, withLivePhotoURL url: URL? = nil) async throws {
        guard photoLibraryPermissionStatus == .authorized else {
            throw PhotoLibraryError.photoLibraryDenied
        }
        do {
            try await photoLibrary.performChanges {
                let createRequest = PHAssetCreationRequest.forAsset()
                createRequest.addResource(with: .photo, data: photoData, options: nil)
                if let url {
                    let options = PHAssetResourceCreationOptions()
                    options.shouldMoveFile = true
                    createRequest.addResource(with: .pairedVideo, fileURL: url, options: options)
                }
            }
        } catch {
            throw PhotoLibraryError.photoSavingFailed
        }
    }
}

public extension PhotoLibraryService {
    var photoLibraryPermissionStatus: PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }

    func requestPhotoLibraryPermission() async {
        await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    }
}

extension PhotoLibraryService: PHPhotoLibraryChangeObserver {
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        photoLibraryChange = changeInstance
    }
}

public enum PhotoLibraryError: LocalizedError {
    case photoNotFound
    case photoSavingFailed
    case photoLibraryDenied
    case photoLoadingFailed
    case unknownError
}

public extension PhotoLibraryError {
    var errorDescription: String? {
        switch self {
        case .photoNotFound:
            return "Photo Not Found"
        case .photoSavingFailed:
            return "Photo Saving Failed"
        case .photoLibraryDenied:
            return "Photo Library Access Denied"
        case .photoLoadingFailed:
            return "Photo Loading Failed"
        case .unknownError:
            return "Unknown Error"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .photoNotFound:
            return "The photo is not found in the photo library."
        case .photoSavingFailed:
            return "Oops! There is an error occurred while saving a photo into the photo library."
        case .photoLibraryDenied:
            return "You need to allow the photo library access to save pictures you captured. Go to Settings and enable the photo library permission."
        case .photoLoadingFailed:
            return "Oops! There is an error occurred while loading a photo from the photo library."
        case .unknownError:
            return "Oops! The unknown error occurs."
        }
    }
}
#endif
