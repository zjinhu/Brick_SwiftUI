//
//  File.swift
//
//
//  Created by HU on 2024/4/23.
//
#if os(iOS)
import PhotosUI
import Photos
import UIKit
import Foundation
import UniformTypeIdentifiers
extension PHPickerResult{
    public func loadImage() async throws -> UIImage? {
        // 调试信息
        itemProvider.debugItemProvider()
        
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        
        // 1. 尝试直接加载 UIImage
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            return try await withCheckedThrowingContinuation { continuation in
                itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    if let image = object as? UIImage {
                        continuation.resume(returning: image)
                    } else {
                        continuation.resume(returning: nil)
                    }
                }
            }
        }
        
        // 2. 尝试通过数据表示加载
        if let data = try await itemProvider.loadData(),
           let image = UIImage(data: data){
            return image
        }
 
        // 3. 如果有 assetIdentifier，尝试通过 PHAsset 加载
        if let assetIdentifier = assetIdentifier {
            
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil)
            if let asset = fetchResult.firstObject {
                return await loadImageFromPHAsset(asset)
            }
        }

        return nil
    }

    func loadImageFromPHAsset(_ asset: PHAsset) async -> UIImage? {
        await withCheckedContinuation { continuation in
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true
            
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: PHImageManagerMaximumSize,
                contentMode: .aspectFit,
                options: options
            ) { image, info in
                continuation.resume(returning: image)
            }
        }
    }
 
}

extension PHPickerResult{
 
    public func loadTransferable<T>(type: T.Type) async throws -> T? where T: NSItemProviderReading {
        itemProvider.debugItemProvider()
        return try await itemProvider.loadObject(type)
    }
    
    public func loadTransfer<T>(type: T.Type) async throws -> T? {
        itemProvider.debugItemProvider()
        do {
            switch type {
            case is UIImage.Type:
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    let image = try await itemProvider.loadObject(UIImage.self)
                    return image as? T
                } else {
                    // 尝试通过数据加载
                    guard let data = try await itemProvider.loadData(),
                          let image = UIImage(data: data) else {
                        throw PhotoError<T>()
                    }
                    return image as? T
                }
            case is Data.Type:
                let data = try await itemProvider.loadData()
                return data as? T
            default:
                throw PhotoError<T>()
            }
        } catch {
            throw PhotoError<T>()
        }
    }
    
    public func loadTransfer<T>(type: T.Type, completion: @escaping (Result<T?, Error>) -> Void){
        Task {
            
            switch type {
            case is UIImage.Type:
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    let image = try await itemProvider.loadObject(UIImage.self)
                    completion(.success(image as? T))
                } else {
                    // 尝试通过数据加载
                    if let data = try await itemProvider.loadData(),
                       let image = UIImage(data: data) {
                        completion(.success(image as? T))
                    }else{
                        completion(.failure(PhotoError<T>()))
                    }
                }

            case is Data.Type:
                let data = try? await itemProvider.loadData()
                completion(.success( data as? T))
            default:
                completion(.failure(PhotoError<T>()))
            }
        }
    }
    
    private struct PhotoError<T>: LocalizedError {
        var errorDescription: String? {
            "Could not load photo as \(T.self)"
        }
    }
}

extension NSItemProvider {
    
    func loadData() async throws -> Data? {
        let supportedRepresentations = [UTType.rawImage.identifier,
                                        UTType.webP.identifier,
                                        UTType.gif.identifier,
                                        UTType.tiff.identifier,
                                        UTType.bmp.identifier,
                                        UTType.heif.identifier,
                                        UTType.heic.identifier,
                                        UTType.livePhoto.identifier,
                                        UTType.jpeg.identifier,
                                        UTType.png.identifier,
                                        UTType.rawImage.identifier,
                                        UTType.svg.identifier,
                                        UTType.movie.identifier,
                                        UTType.video.identifier,
                                        UTType.quickTimeMovie.identifier,
                                        UTType.mpeg.identifier,
                                        UTType.mpeg2Video.identifier,
                                        UTType.mpeg4Movie.identifier,
                                        UTType.appleProtectedMPEG4Video.identifier,
                                        UTType.avi.identifier,
                                        UTType.url.identifier]
        
        for representation in supportedRepresentations {
            if self.hasItemConformingToTypeIdentifier(representation) {
                return try await self.loadDataRepresentation(forTypeIdentifier: representation)
            }
        }
        print("没有找到支持的图片类型")
        return nil
    }
    
    func loadDataRepresentation(forTypeIdentifier typeIdentifier: String) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            self.loadDataRepresentation(forTypeIdentifier: typeIdentifier) { data, error in
                if let error = error {
                    return continuation.resume(throwing: error)
                }
                
                if let data = data{
                    return continuation.resume(returning: data)
                }
                
                if let url = data as? URL, let data = try? Data(contentsOf: url){
                    return continuation.resume(returning: data)
                }

                return continuation.resume(throwing: NSError(domain: "com.app.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "无法加载图片数据"]))
            }
        }
    }
}

extension NSItemProvider {
 
    func debugItemProvider() {
        print("支持的类型标识符: \(registeredTypeIdentifiers)")
        
        for type in registeredTypeIdentifiers {
            print("类型: \(type), 是否可加载: \(hasItemConformingToTypeIdentifier(type))")
        }
    }
    
    func loadObject<T: NSItemProviderReading>(_ type: T.Type = T.self) async throws -> T?{
        try await withCheckedThrowingContinuation { continuation in
            _ = self.loadObject(ofClass: T.self) { object, error in
                if let error {
                    return continuation.resume(throwing: error)
                }
                continuation.resume(returning: object as? T)
            }
        }
    }
}
#endif
