//
//  File.swift
//
//
//  Created by HU on 2024/4/23.
//
import PhotosUI
import Photos
import UIKit
import Foundation
import UniformTypeIdentifiers

extension PHPickerResult{
    
    public func loadTransferable<T>(type: T.Type) async throws -> T? where T: NSItemProviderReading {
        try await itemProvider.loadObject(type)
    }
    
    public func loadTransfer<T>(type: T.Type) async throws -> T? {
        do {
            let data = try await itemProvider.loadData()
            
            switch type {
            case is UIImage.Type:
                guard let image = UIImage(data: data) else { return nil }
                return image as? T
            case is Data.Type:
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
            let data = try? await itemProvider.loadData()
            switch type {
            case is UIImage.Type:
                if let data = data,
                   let image = UIImage(data: data) {
                    completion(.success(image as? T))
                }else{
                    completion(.failure(PhotoError<T>()))
                }
            case is Data.Type:
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
    
    func loadData() async throws -> Data {
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
                                        UTType.avi.identifier  ]
        
        for representation in supportedRepresentations {
            if self.hasItemConformingToTypeIdentifier(representation) {
                return try await self.loadDataRepresentation(forTypeIdentifier: representation)
            }
        }
        
        return try await self.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier)
    }
    
    func loadDataRepresentation(forTypeIdentifier typeIdentifier: String) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            self.loadDataRepresentation(forTypeIdentifier: typeIdentifier) { data, error in
                if let error = error {
                    return continuation.resume(throwing: error)
                }
                
                guard let data = data else {
                    return continuation.resume(throwing: NSError())
                }
                
                continuation.resume(returning: data)
            }.resume()
        }
    }
}

extension NSItemProvider {
 
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
