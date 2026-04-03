import SwiftUI

/// 提议视图尺寸结构体
/// Proposed view size struct
public struct ProposedViewSize: Equatable, Sendable {
    public var width: CGFloat?
    public var height: CGFloat?
    
    /// 零尺寸 / Zero size
    public static let zero = Self(width: 0, height: 0)
    /// 无限尺寸 / Infinity size
    public static let infinity = Self(width: .infinity, height: .infinity)
    /// 未指定尺寸 / Unspecified size
    public static let unspecified = Self(width: nil, height: nil)
    
    /// 使用 CGSize 初始化
    /// Initialize with CGSize
    /// - Parameter size: CGSize
    public init(_ size: CGSize) {
        self.width = size.width
        self.height = size.height
    }
    
    /// 使用可选宽高初始化
    /// Initialize with optional width and height
    /// - Parameters:
    ///   - width: 宽度 / Width
    ///   - height: 高度 / Height
    public init(width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
    }
    
    /// 替换未指定尺寸
    /// Replace unspecified dimensions
    /// - Parameter size: 默认尺寸 / Default size
    /// - Returns: CGSize with replaced dimensions
    public func replacingUnspecifiedDimensions(by size: CGSize) -> CGSize {
        .init(
            width: width ?? size.width, 
            height: height ?? size.height
        )
    }
}
