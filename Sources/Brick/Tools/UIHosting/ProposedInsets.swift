import SwiftUI

/// 提供可选的插入值。`nil`表示使用系统默认值/Provides optional inset values. `nil` is interpreted as: use system default
internal struct ProposedInsets: Equatable {

    /// 提议的前导边距（点）/The proposed leading margin measured in points.
    ///
    /// `nil`值告诉系统使用默认值/A value of `nil` tells the system to use a default value
    public var leading: CGFloat?

    /// 提议的尾随边距（点）/The proposed trailing margin measured in points.
    ///
    /// `nil`值告诉系统使用默认值/A value of `nil` tells the system to use a default value
    public var trailing: CGFloat?

    /// 提议的顶部边距（点）/The proposed top margin measured in points.
    ///
    /// `nil`值告诉系统使用默认值/A value of `nil` tells the system to use a default value
    public var top: CGFloat?

    /// 提议的底部边距（点）/The proposed bottom margin measured in points.
    ///
    /// `nil`值告诉系统使用默认值/A value of `nil` tells the system to use a default value
    public var bottom: CGFloat?

    /// 所有维度都未指定的插入提议/An insets proposal with all dimensions left unspecified.
    public static var unspecified: ProposedInsets { .init() }

    /// 所有维度都为零的插入提议/An insets proposal that contains zero for all dimensions.
    public static var zero: ProposedInsets { .init(leading: 0, trailing: 0, top: 0, bottom: 0) }

}
