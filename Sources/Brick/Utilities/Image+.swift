//
//
//  Created by iOS on 2023/6/28.
//
//

import Foundation
import UIKit
import SwiftUI
#if canImport(AppKit)
import class AppKit.NSImage

/**
 This typealias helps bridging UIKit and AppKit when working
 with images in a multi-platform context.
 */
public typealias ImageRepresentable = NSImage
#endif

#if canImport(UIKit)
import class UIKit.UIImage

/**
 This typealias helps bridging UIKit and AppKit when working
 with images in a multi-platform context.
 */
public typealias ImageRepresentable = UIImage
#endif

public extension Image {
    
    /// Create an image from a certain ``ImageRepresentable``.
    init(image: ImageRepresentable) {
        #if canImport(UIKit)
        self.init(uiImage: image)
        #elseif canImport(AppKit)
        self.init(nsImage: image)
        #endif
    }
}

public extension ImageRepresentable {
    
    /// Get resized and compressed JPG data from the image.
    ///
    /// - Parameters:
    ///   - width: The width of the new image, by default `1000`.
    ///   - quality: The compression quality, by default `0.8`.
    func jpegData(
        resizedToWidth width: CGFloat = 1000,
        withCompressionQuality quality: CGFloat = 0.8
    ) -> Data? {
        let resized = self.resized(toWidth: width)
        let image = resized ?? self
        return image.jpegData(compressionQuality: quality)
    }
}


public extension ImageRepresentable {

    /// Create a resized copy of the image with a new height.
    func resized(toHeight points: CGFloat) -> ImageRepresentable? {
        let ratio = points / size.height
        let width = size.width * ratio
        let newSize = CGSize(width: width, height: points)
        return resized(to: newSize)
    }

    /// Create a resized copy of the image with a max height.
    func resized(toMaxHeight points: CGFloat) -> ImageRepresentable? {
        if size.height < points { return self }
        return resized(toHeight: points)
    }

    /// Create a resized copy of the image, with a new width.
    func resized(toWidth points: CGFloat) -> ImageRepresentable? {
        let ratio = points / size.width
        let height = size.height * ratio
        let newSize = CGSize(width: points, height: height)
        return resized(to: newSize)
    }

    /// Create a resized copy of the image, with a max width.
    func resized(toMaxWidth points: CGFloat) -> ImageRepresentable? {
        if size.width < points { return self }
        return resized(toWidth: points)
    }
}


#if canImport(AppKit)
import AppKit

public extension NSImage {

    /// Create a resized copy of the image.
    func resized(to newSize: CGSize) -> NSImage? {
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        let sourceRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        let destRect = NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        draw(in: destRect, from: sourceRect, operation: .sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        return newImage
    }
}
#endif


#if canImport(UIKit)
import UIKit

public extension UIImage {

    /// Create a resized copy of the image.
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
#endif


#if os(macOS)
import AppKit
import Cocoa
import CoreGraphics

public extension NSImage {
    
    /// Get the image's core graphics image representation.
    var cgImage: CGImage? {
        cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    
    /// Get the image's JPEG data representation.
    func jpegData(compressionQuality: CGFloat) -> Data? {
        guard let image = cgImage else { return nil }
        let bitmap = NSBitmapImageRep(cgImage: image)
        return bitmap.representation(using: .jpeg, properties: [.compressionFactor: compressionQuality])
    }
}
#endif

#if os(iOS)
import UIKit

public extension UIImage {
    
    /// Copies the image as png data to the pasteboard.
    func copyToPasteboard(_ pasteboard: UIPasteboard = .general) -> Bool {
        guard let data = pngData() else { return false }
        pasteboard.setData(data, forPasteboardType: "public.png")
        return true
    }
}

public extension UIImage {
    
    /// Save the image to the user's photo album.
    ///
    /// This requires the correct permission in `Info.plist`.
    /// Failing to add these permissions before calling this
    /// function will crash the app.
    func saveToPhotos(completion: @escaping (Error?) -> Void) {
        ImageService.default.saveImageToPhotos(self, completion: completion)
    }
}

private class ImageService: NSObject {
    
    public typealias Completion = (Error?) -> Void

    public static private(set) var `default` = ImageService()
    
    private var completions = [Completion]()
    
    public func saveImageToPhotos(_ image: UIImage, completion: @escaping (Error?) -> Void) {
        completions.append(completion)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImageToPhotosDidComplete), nil)
    }
    
    @objc func saveImageToPhotosDidComplete(_ image: UIImage, error: NSError?, contextInfo: UnsafeRawPointer) {
        guard completions.count > 0 else { return }
        completions.removeFirst()(error)
    }
}

public extension UIImage {
    
    /// Rotate an image a certain amount of radians.
    func rotated(withRadians radians: Float) -> UIImage? {
        let radians = CGFloat(radians)
        let transform = CGAffineTransform(rotationAngle: radians)
        var newSize = CGRect(origin: .zero, size: size)
            .applying(transform)
            .size
        
        // Trim off the small float values to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        
        // Draw the image at its center
        let rect = CGRect(
            x: -size.width/2,
            y: -size.height/2,
            width: size.width,
            height: size.height)
        
        // Draw new image
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

import CoreGraphics

public extension UIImage {
    
    /// Create a tinted copy of the image.
    func tinted(with color: UIColor, blendMode: CGBlendMode) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        draw(in: rect, blendMode: blendMode, alpha: 1.0)
        context?.setBlendMode(blendMode)
        color.setFill()
        context?.fill(rect)
        draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
}
#endif
