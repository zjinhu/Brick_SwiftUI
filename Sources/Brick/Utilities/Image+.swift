//
//  Image++.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  图像工具类 - 提供图像缩放、格式转换、裁剪等功能 / Image utility - provides image scaling, format conversion, cropping, etc.
//

import Foundation
import SwiftUI
#if canImport(AppKit)
import class AppKit.NSImage

/// 平台图像类型别名 - 用于跨平台图像处理 / Platform image typealias for cross-platform image handling
public typealias ImageRepresentable = NSImage
#endif

#if canImport(UIKit)
import UIKit
import class UIKit.UIImage

/// 平台图像类型别名 - 用于跨平台图像处理 / Platform image typealias for cross-platform image handling
public typealias ImageRepresentable = UIImage
#endif

// MARK: - SwiftUI Image Extension / SwiftUI Image 扩展

/// 从 ImageRepresentable 创建 SwiftUI Image / Create SwiftUI Image from ImageRepresentable
public extension Image {
    /// 初始化 SwiftUI Image / Initialize SwiftUI Image
    /// - Parameter image: 平台图像 / Platform image
    init(image: ImageRepresentable) {
        #if canImport(UIKit)
        self.init(uiImage: image)
        #elseif canImport(AppKit)
        self.init(nsImage: image)
        #endif
    }
}

// MARK: - ImageRepresentable Extension / ImageRepresentable 扩展

public extension ImageRepresentable {
    
    /// 获取调整大小并压缩的 JPEG 数据 / Get resized and compressed JPG data from the image
    /// - Parameters:
    ///   - width: 新图像宽度，默认 1000 / The width of the new image, by default 1000
    ///   - quality: 压缩质量，默认 0.8 / The compression quality, by default 0.8
    /// - Returns: JPEG 数据 / JPEG data
    func jpegData(
        resizedToWidth width: CGFloat = 1000,
        withCompressionQuality quality: CGFloat = 0.8
    ) -> Data? {
        let resized = self.resized(toWidth: width)
        let image = resized ?? self
        return image.jpegData(compressionQuality: quality)
    }
}


// MARK: - ImageRepresentable Resize Extension / ImageRepresentable 缩放扩展

public extension ImageRepresentable {

    /// 创建调整高度后的图像副本 / Create a resized copy of the image with a new height
    /// - Parameter points: 目标高度 / Target height
    /// - Returns: 调整后的图像 / Resized image
    func resized(toHeight points: CGFloat) -> ImageRepresentable? {
        let ratio = points / size.height
        let width = size.width * ratio
        let newSize = CGSize(width: width, height: points)
        return resized(to: newSize)
    }

    /// 创建最大高度限制的图像副本 / Create a resized copy of the image with a max height
    /// - Parameter points: 最大高度 / Max height
    /// - Returns: 调整后的图像 / Resized image
    func resized(toMaxHeight points: CGFloat) -> ImageRepresentable? {
        if size.height < points { return self }
        return resized(toHeight: points)
    }

    /// 创建调整宽度后的图像副本 / Create a resized copy of the image, with a new width
    /// - Parameter points: 目标宽度 / Target width
    /// - Returns: 调整后的图像 / Resized image
    func resized(toWidth points: CGFloat) -> ImageRepresentable? {
        let ratio = points / size.width
        let height = size.height * ratio
        let newSize = CGSize(width: points, height: height)
        return resized(to: newSize)
    }

    /// 创建最大宽度限制的图像副本 / Create a resized copy of the image, with a max width
    /// - Parameter points: 最大宽度 / Max width
    /// - Returns: 调整后的图像 / Resized image
    func resized(toMaxWidth points: CGFloat) -> ImageRepresentable? {
        if size.width < points { return self }
        return resized(toWidth: points)
    }
}


// MARK: - NSImage Resize Extension / NSImage 缩放扩展

#if canImport(AppKit)
import AppKit

/// NSImage 缩放扩展 / NSImage resize extension
public extension NSImage {

    /// 创建调整大小后的图像副本 / Create a resized copy of the image
    /// - Parameter newSize: 目标尺寸 / Target size
    /// - Returns: 调整后的图像 / Resized image
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


// MARK: - UIImage Resize Extension / UIImage 缩放扩展

#if canImport(UIKit)
import UIKit

/// UIImage 缩放扩展 / UIImage resize extension
public extension UIImage {

    /// 创建调整大小后的图像副本 / Create a resized copy of the image
    /// - Parameter size: 目标尺寸 / Target size
    /// - Returns: 调整后的图像 / Resized image
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
#endif


// MARK: - macOS NSImage Extension / macOS NSImage 扩展

#if os(macOS)
import AppKit
import Cocoa
import CoreGraphics

/// NSImage 扩展 (macOS) / NSImage extension (macOS)
public extension NSImage {
    
    /// 获取图像的核心图形表示 / Get the image's core graphics image representation
    var cgImage: CGImage? {
        cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    
    /// 获取图像的 JPEG 数据表示 / Get the image's JPEG data representation
    /// - Parameter compressionQuality: 压缩质量 (0-1) / Compression quality (0-1)
    /// - Returns: JPEG 数据 / JPEG data
    func jpegData(compressionQuality: CGFloat) -> Data? {
        guard let image = cgImage else { return nil }
        let bitmap = NSBitmapImageRep(cgImage: image)
        return bitmap.representation(using: .jpeg, properties: [.compressionFactor: compressionQuality])
    }
}
#endif

// MARK: - iOS UIImage Extension / iOS UIImage 扩展

#if os(iOS)
import UIKit

/// UIImage 扩展 (iOS) / UIImage extension (iOS)
public extension UIImage {
    
    /// 复制图像为 PNG 数据到剪贴板 / Copies the image as png data to the pasteboard
    /// - Parameter pasteboard: 剪贴板 / Pasteboard
    /// - Returns: 是否成功 / Whether successful
    func copyToPasteboard(_ pasteboard: UIPasteboard = .general) -> Bool {
        guard let data = pngData() else { return false }
        pasteboard.setData(data, forPasteboardType: "public.png")
        return true
    }
}

/// 图像保存服务 / Image save service
public extension UIImage {
    
    /// 保存图像到用户相册 / Save the image to the user's photo album
    /// - 注意: 需要在 Info.plist 中添加权限 / Note: Requires correct permission in Info.plist
    /// - Parameter completion: 保存完成回调 / Save completion callback
    @MainActor func saveToPhotos(completion: @escaping (Error?) -> Void) {
        ImageService.default.saveImageToPhotos(self, completion: completion)
    }
}

/// 图像服务类 / Image service class
private class ImageService: NSObject {
    
    public typealias Completion = (Error?) -> Void
    @MainActor
    public static private(set) var `default` = ImageService()
    
    private var completions = [Completion]()
    
    /// 保存图像到相册 / Save image to photos
    public func saveImageToPhotos(_ image: UIImage, completion: @escaping (Error?) -> Void) {
        completions.append(completion)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImageToPhotosDidComplete), nil)
    }
    
    @objc func saveImageToPhotosDidComplete(_ image: UIImage, error: NSError?, contextInfo: UnsafeRawPointer) {
        guard completions.count > 0 else { return }
        completions.removeFirst()(error)
    }
}

/// 图像旋转扩展 / Image rotation extension
public extension UIImage {
    
    /// 旋转图像 / Rotate an image a certain amount of radians
    /// - Parameter radians: 旋转弧度 / Rotation radians
    /// - Returns: 旋转后的图像 / Rotated image
    func rotated(withRadians radians: Float) -> UIImage? {
        let radians = CGFloat(radians)
        let transform = CGAffineTransform(rotationAngle: radians)
        var newSize = CGRect(origin: .zero, size: size)
            .applying(transform)
            .size
        
        // 去除小数点防止 core graphics 四舍五入 / Trim off the small float values to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        let context = UIGraphicsGetCurrentContext()!

        // 将原点移动到中心 / Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        
        // 围绕中心旋转 / Rotate around middle
        context.rotate(by: CGFloat(radians))
        
        // 在中心绘制图像 / Draw the image at its center
        let rect = CGRect(
            x: -size.width/2,
            y: -size.height/2,
            width: size.width,
            height: size.height)
        
        // 绘制新图像 / Draw new image
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

import CoreGraphics

/// 图像染色扩展 / Image tint extension
public extension UIImage {
    
    /// 创建带颜色的着色图像副本 / Create a tinted copy of the image
    /// - Parameters:
    ///   - color: 着色颜色 / Tint color
    ///   - blendMode: 混合模式 / Blend mode
    /// - Returns: 着色后的图像 / Tinted image
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


// MARK: - Image Format / 图像格式

/// 图像格式枚举 / Image format enumeration
public enum ImageFormat: String {
    case png, jpg, gif, tiff, webp, heic, unknown
}

/// ImageFormat 扩展 / ImageFormat extension
public extension ImageFormat {
    /// 从数据获取图像格式 / Get image format from data
    /// - Parameter data: 图像数据 / Image data
    /// - Returns: 图像格式 / Image format
    static func get(from data: Data) -> ImageFormat {
       switch data[0] {
       case 0x89:
           return .png
       case 0xFF:
           return .jpg
       case 0x47:
           return .gif
       case 0x49, 0x4D:
           return .tiff
       case 0x52 where data.count >= 12:
           let subdata = data[0...11]

           if let dataString = String(data: subdata, encoding: .ascii),
               dataString.hasPrefix("RIFF"),
               dataString.hasSuffix("WEBP")
           {
               return .webp
           }

       case 0x00 where data.count >= 12 :
           let subdata = data[8...11]

           if let dataString = String(data: subdata, encoding: .ascii),
               Set(["heic", "heix", "hevc", "hevx"]).contains(dataString)
           {
               return .heic
           }
       default:
           break
       }
       return .unknown
    }
    
    /// 获取 Content-Type 字符串 / Get Content-Type string
    var contentType: String {
        return "image/\(rawValue)"
    }
}
