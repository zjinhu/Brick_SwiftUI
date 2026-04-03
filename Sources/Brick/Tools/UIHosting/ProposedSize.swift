import SwiftUI

/// 尺寸提议/A proposal for the size
///
/// * ``zero`` 提议：尺寸以最小尺寸响应/The ``zero`` proposal; the size responds with its minimum size.
/// * ``infinity`` 提议：尺寸以最大尺寸响应/The ``infinity`` proposal; the size responds with its maximum size.
/// * ``unspecified`` 提议：尺寸以系统默认尺寸响应/The ``unspecified`` proposal; the size responds with its system default size.
internal struct ProposedSize: Equatable, Sendable {

    /// 提议的水平尺寸（点）/The proposed horizontal size measured in points.
    ///
    /// `nil`值表示未指定的宽度提议/A value of `nil` represents an unspecified width proposal.
    public var width: CGFloat?

    /// 提议的垂直尺寸（点）/The proposed vertical size measured in points.
    ///
    /// `nil`值表示未指定的高度提议/A value of `nil` represents an unspecified height proposal.
    public var height: CGFloat?

    /// 包含两个维度都为零的尺寸提议/A size proposal that contains zero in both dimensions.
    public static var zero: ProposedSize { .init(width: 0, height: 0) }

    /// 两个维度都未指定的尺寸提议/The proposed size with both dimensions left unspecified.
    ///
    /// 此尺寸提议中两个维度都包含 `nil`/Both dimensions contain `nil` in this size proposal.
    public static var unspecified: ProposedSize { .init(width: nil, height: nil) }

    /// 包含两个维度都为无穷大的尺寸提议/A size proposal that contains infinity in both dimensions.
    ///
    /// 此尺寸提议中两个维度都包含 `.infinity`/Both dimensions contain .infinity in this size proposal.
    public static var infinity: ProposedSize { .init(width: .infinity, height: .infinity) }

    /// 使用指定的宽度和高度创建新的提议尺寸/Creates a new proposed size using the specified width and height.
    ///
    /// - Parameters:
    ///   - width: 提议的宽度（点）。使用 `nil` 值表示此提议未指定宽度/A proposed width in points. Use a value of `nil` to indicate that the width is unspecified for this proposal.
    ///   - height: 提议的高度（点）。使用 `nil` 值表示此提议未指定高度/A proposed height in points. Use a value of `nil` to indicate that the height is unspecified for this proposal.
    @inlinable public init(width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
    }

    /// 从指定尺寸创建新的提议尺寸/Creates a new proposed size from a specified size.
    ///
    /// - Parameter size: 包含维度尺寸（点）的提议尺寸/A proposed size with dimensions measured in points.
    @inlinable public init(_ size: CGSize) {
        self.width = size.width
        self.height = size.height
    }

}
