//
//  Image++.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  Image 扩展 - 提供 Image 的便捷初始化和调整方法 / Image extension - provides convenient Image initialization and adjustment methods
//

import SwiftUI

// MARK: - Image Symbol Extension / Image Symbol 扩展

/// Image Symbol 扩展 / Image symbol extension
public extension Image {
    
    /// 从字符串创建 Image (SF Symbol) / Create Image from String (SF Symbol)
    /// - Parameter name: SF Symbol 名称 / SF Symbol name
    /// - Returns: Image 实例 / Image instance
    static func symbol(_ name: String) -> Image {
        .init(systemName: name)
    }
    
    /// 从 SFSymbolName 创建 Image / Create Image from SFSymbolName
    /// - Parameter symbol: SFSymbolName 类型 / SFSymbolName type
    init(symbol: SFSymbolName) {
        self.init(systemName: symbol.symbolName)
    }
}

// MARK: - Image Resize Extension / Image 缩放扩展

/// Image 缩放扩展 / Image resize extension
public extension Image {

    /// 调整图像大小 / Resize the image with a certain content mode
    /// - Parameter mode: 内容模式 (fit/fill) / Content mode (fit/fill)
    /// - Returns: 可调整大小的 Image / Resizable Image
    func resized(to mode: ContentMode) -> some View {
        self.resizable()
            .aspectRatio(contentMode: mode)
    }
}

// MARK: - Image SizeToFit Extension / Image 适应尺寸扩展

/// Image 适应尺寸扩展 / Image size to fit extension
extension Image {

    /// 适应指定尺寸 (保持宽高比) / Fit to specified size (maintain aspect ratio)
    /// - Parameters:
    ///   - width: 宽度 / Width
    ///   - height: 高度 / Height
    ///   - alignment: 对齐方式 / Alignment
    /// - Returns: 适应尺寸的 Image / Image fitted to size
    public func sizeToFit(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height, alignment: alignment)
    }
    
    /// 适应指定尺寸 (CGSize 版本) / Fit to specified size (CGSize version)
    @_disfavoredOverload
    public func sizeToFit(
        _ size: CGSize? = nil,
        alignment: Alignment = .center
    ) -> some View {
        sizeToFit(width: size?.width, height: size?.height, alignment: alignment)
    }
    
    /// 适应正方形尺寸 / Fit to square size
    /// - Parameters:
    ///   - sideLength: 边长 / Side length
    ///   - alignment: 对齐方式 / Alignment
    /// - Returns: 适应正方形的 Image / Image fitted to square
    public func sizeToFitSquare(
        sideLength: CGFloat?,
        alignment: Alignment = .center
    ) -> some View {
        sizeToFit(width: sideLength, height: sideLength, alignment: alignment)
    }
}
