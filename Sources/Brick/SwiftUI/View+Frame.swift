//
//  View+Frame.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  视图框架扩展 - 提供便捷的框架设置方法 / View frame extension - provides convenient frame setting methods
//

import SwiftUI

// MARK: - Min/Max Width & Height / 最小/最大宽高

/// 视图框架扩展 / View frame extension
extension View {
    /// 设置最小宽度 / Set min width
    /// - Parameter width: 宽度值 / Width value
    @inlinable
    public func minWidth(_ width: CGFloat?) -> some View {
        frame(minWidth: width)
    }
    
    /// 设置最大宽度 / Set max width
    /// - Parameters:
    ///   - width: 宽度值 / Width value
    ///   - alignment: 对齐方式 / Alignment
    @inlinable
    public func maxWidth(_ width: CGFloat?, alignment: Alignment = .center) -> some View {
        frame(maxWidth: width, alignment: alignment)
    }
    
    /// 设置最小高度 / Set min height
    /// - Parameter height: 高度值 / Height value
    @inlinable
    public func minHeight(_ height: CGFloat?) -> some View {
        frame(minHeight: height)
    }
    
    /// 设置最大高度 / Set max height
    /// - Parameter height: 高度值 / Height value
    @inlinable
    public func maxHeight(_ height: CGFloat?) -> some View {
        frame(maxHeight: height)
    }
    
    /// 设置指定轴的最小尺寸 / Set min dimension for specified axis
    /// - Parameters:
    ///   - dimensionLength: 尺寸值 / Dimension length
    ///   - axis: 轴方向 / Axis
    @inlinable
    public func frame(min dimensionLength: CGFloat,
                      axis: Axis) -> some View {
        switch axis {
        case .horizontal:
            return frame(minWidth: dimensionLength)
        case .vertical:
            return frame(minWidth: dimensionLength)
        }
    }
}

// MARK: - Width & Height / 宽高

/// 宽高设置扩展 / Width & height extension
extension View {
    /// 设置宽度 / Set width
    /// - Parameter width: 宽度值 / Width value
    @inlinable
    public func width(_ width: CGFloat?) -> some View {
        frame(width: width)
    }
    
    /// 设置高度 / Set height
    /// - Parameter height: 高度值 / Height value
    @inlinable
    public func height(_ height: CGFloat?) -> some View {
        frame(height: height)
    }
    
    /// 设置框架尺寸 / Set frame size
    /// - Parameters:
    ///   - size: CGSize 尺寸 / CGSize
    ///   - alignment: 对齐方式 / Alignment
    @inlinable
    public func frame(_ size: CGSize?,
                      alignment: Alignment = .center) -> some View {
        frame(width: size?.width,
              height: size?.height,
              alignment: alignment)
    }
    
    /// 设置最小框架尺寸 / Set min frame size
    @inlinable
    public func frame(min size: CGSize?,
                      alignment: Alignment = .center) -> some View {
        frame(minWidth: size?.width,
              minHeight: size?.height,
              alignment: alignment)
    }
    
    /// 设置最大框架尺寸 / Set max frame size
    @inlinable
    public func frame(max size: CGSize?,
                      alignment: Alignment = .center) -> some View {
        frame(maxWidth: size?.width,
              maxHeight: size?.height,
              alignment: alignment)
    }
    
    /// 设置最小和最大框架尺寸 / Set min and max frame size
    @inlinable
    public func frame(min minSize: CGSize?,
                      max maxSize: CGSize?,
                      alignment: Alignment = .center) -> some View {
        frame(minWidth: minSize?.width,
              maxWidth: maxSize?.width,
              minHeight: minSize?.height,
              maxHeight: maxSize?.height,
              alignment: alignment)
    }
    
    /// 使用范围设置框架 / Set frame with range
    @_disfavoredOverload
    public func frame(width: ClosedRange<CGFloat>? = nil,
                      idealWidth: CGFloat? = nil,
                      height: ClosedRange<CGFloat>? = nil,
                      idealHeight: CGFloat? = nil) -> some View {
        frame(minWidth: width?.lowerBound,
              idealWidth: idealWidth,
              maxWidth: width?.upperBound,
              minHeight: height?.lowerBound,
              idealHeight: idealHeight,
              maxHeight: height?.upperBound)
    }
}

// MARK: - Relative Size / 相对尺寸

/// 相对尺寸扩展 / Relative size extension
extension View {
    /// 相对高度 (基于父视图) / Relative height (based on parent)
    /// - Parameters:
    ///   - ratio: 比例 / Ratio
    ///   - alignment: 对齐方式 / Alignment
    @inlinable
    public func relativeHeight(_ ratio: CGFloat,
                               alignment: Alignment = .center) -> some View {
        GeometryReader { geometry in
            self.frame(height: geometry.size.height * ratio,
                       alignment: alignment)
        }
    }
    
    /// 相对宽度 (基于父视图) / Relative width (based on parent)
    @inlinable
    public func relativeWidth(_ ratio: CGFloat,
                              alignment: Alignment = .center) -> some View {
        GeometryReader { geometry in
            self.frame(width: geometry.size.width * ratio,
                       alignment: alignment)
        }
    }
    
    /// 相对尺寸 (基于父视图) / Relative size (based on parent)
    @inlinable
    public func relativeSize(width widthRatio: CGFloat?,
                             height heightRatio: CGFloat?,
                             alignment: Alignment = .center) -> some View {
        GeometryReader { geometry in
            self.frame(width: widthRatio.map({ $0 * geometry.size.width }),
                       height: heightRatio.map({ $0 * geometry.size.height }),
                       alignment: alignment)
        }
    }
}

// MARK: - Read Size / 读取尺寸

/// 读取尺寸扩展 / Read size extension
public extension View {
    /// 读取视图高度 / Read view height
    /// - Parameter action: 高度回调 / Height callback
    func readHeight(onChange action: @escaping (CGFloat) -> ()) -> some View {
        background(heightReader)
            .onPreferenceChange(ReadSizePreferenceKey.self, perform: action)
    }
    
    /// 读取视图宽度 / Read view width
    /// - Parameter action: 宽度回调 / Width callback
    func readWidth(onChange action: @escaping (CGFloat) -> ()) -> some View {
        background(widthReader)
            .onPreferenceChange(ReadSizePreferenceKey.self, perform: action)
    }
}

private extension View {
    var heightReader: some View {
        GeometryReader {
            Color.clear
                .preference(key: ReadSizePreferenceKey.self, value: $0.size.height)
        }
    }
    
    var widthReader: some View {
        GeometryReader {
            Color.clear
                .preference(key: ReadSizePreferenceKey.self, value: $0.size.width)
        }
    }
}

fileprivate struct ReadSizePreferenceKey: @preconcurrency PreferenceKey {
    @MainActor static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

// MARK: - GetSize Modifier / 获取尺寸修饰器

/// 获取尺寸修饰器 / Get size modifier
public struct GetSizeModifier: ViewModifier {
    
    @Binding
    public var currentSize: CGSize
    
    public init(currentSize: Binding<CGSize>) {
        self._currentSize = currentSize
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            currentSize = geometry.size
                        }
                        .ss.onChange(of: geometry.size) { newSize in
                            currentSize = newSize
                        }
                }
            )
    }
}

// MARK: - Ideal Frame / 理想框架

/// 理想框架扩展 / Ideal frame extension
extension View {
    
    /// 理想框架 / Ideal frame
    /// - Parameters:
    ///   - width: 宽度 / Width
    ///   - height: 高度 / Height
    @inlinable
    public func idealFrame(width: CGFloat?,
                           height: CGFloat?) -> some View {
        frame(idealWidth: width,
              idealHeight: height)
    }
    
    /// 最小和理想框架 / Min and ideal frame
    @inlinable
    public func idealMinFrame(width: CGFloat?,
                              maxWidth: CGFloat? = nil,
                              height: CGFloat?,
                              maxHeight: CGFloat? = nil) -> some View {
        frame(minWidth: width,
              idealWidth: width,
              maxWidth: maxWidth,
              minHeight: height,
              idealHeight: height,
              maxHeight: maxHeight)
    }
}

// MARK: - Square Frame / 正方形框架

/// 正方形框架扩展 / Square frame extension
extension View {
    /// 指定边长的正方形 / Square with specified side length
    @inlinable
    public func squareFrame(sideLength: CGFloat?,
                           alignment: Alignment = .center) -> some View {
        frame(width: sideLength,
              height: sideLength,
              alignment: alignment)
    }
    
    /// 自动适应父视图最小边长的正方形 / Auto square based on parent min dimension
    @inlinable
    public func squareFrame() -> some View {
        GeometryReader { geometry in
            self.frame(width: geometry.size.minimumDimensionLength,
                       height: geometry.size.minimumDimensionLength)
        }
    }
}

// MARK: - Frame Zero Clipped / 零框架裁剪

/// 零框架裁剪扩展 / Frame zero clipped extension
extension View {
    /// 裁剪为零框架 / Clip to zero frame
    /// - Parameter clipped: 是否裁剪 / Whether clipped
    @inlinable
    public func frameZeroClipped(_ clipped: Bool = true) -> some View {
        frame(clipped ? .zero : nil)
            .clipped()
    }
}
