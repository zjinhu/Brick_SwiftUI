//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI

extension GridItem {
    /// 创建一个填充可用空间的弹性网格项。/ Creates a flexible grid item that fills available space.
    /// - Parameters:
    ///   - spacing: 此网格项中项目之间的间距。/ The spacing between items in this grid item.
    ///   - alignment: 此网格项中项目的对齐方式。/ The alignment of items within this grid item.
    /// - Returns: 填充可用空间的弹性GridItem。/ A flexible GridItem that expands to fill available space.
    public static func flexible(spacing: CGFloat? = nil,
                                alignment: Alignment? = nil) -> Self {
        GridItem(.flexible(),
                 spacing: spacing,
                 alignment: alignment)
    }
    
    /// 创建一个自适应网格项，在可用空间内尽可能多地排列列。/ Creates an adaptive grid item that fits as many columns as possible within the available space.
    /// - Parameters:
    ///   - minimum: 每列的最小宽度。/ The minimum width for each column.
    ///   - maximum: 每列的最大宽度。/ The maximum width for each column.
    /// - Returns: 根据可用宽度调整列数的自适应GridItem。/ An adaptive GridItem that adjusts column count based on available width.
    static func adaptive(minimum: CGFloat,
                         maximum: CGFloat) -> Self {
        .init(.adaptive(minimum: minimum,
                        maximum: maximum))
    }
    
    /// 创建一个具有特定宽度的固定大小网格项。/ Creates a fixed-size grid item with a specific width/height.
    /// - Parameter size: 此网格项的固定大小。/ The fixed size for this grid item.
    /// - Returns: 固定大小的GridItem。/ A fixed-size GridItem.
    static func fixed(_ size: CGFloat) -> Self {
        .init(.fixed(size))
    }
    
    /// 创建具有最小和最大尺寸约束的弹性网格项。/ Creates a flexible grid item with minimum and maximum size constraints.
    /// - Parameters:
    ///   - minimum: 此网格项的最小宽度。/ The minimum width for this grid item.
    ///   - maximum: 此网格项的最大宽度。/ The maximum width for this grid item.
    /// - Returns: 具有尺寸约束的弹性GridItem。/ A flexible GridItem with size constraints.
    static func flexible(minimum: CGFloat,
                         maximum: CGFloat) -> Self {
        .init(.flexible(minimum: minimum,
                        maximum: maximum))
    }
}

extension GridItem.Size {
    /// 创建最小值和最大值相等的自适应尺寸。/ Creates an adaptive size with equal minimum and maximum values.
    /// - Parameter size: 最小值和最大值共用的尺寸。/ The size for both minimum and maximum.
    /// - Returns: 自适应的GridItem.Size。/ An adaptive GridItem.Size.
    public static func adaptive(_ size: CGFloat) -> Self {
        .adaptive(minimum: size,
                  maximum: size)
    }
}

public extension Collection where Element == GridItem {
    
    /// 创建在可用空间内尽可能多地排列列的自适应网格项数组。/ Creates an array of adaptive grid items that fit as many columns as possible within the available space.
    /// - Parameters:
    ///   - minimum: 每列的最小宽度。/ The minimum width for each column.
    ///   - maximum: 每列的最大宽度。/ The maximum width for each column.
    /// - Returns: 自适应GridItem的数组。/ An array of adaptive GridItems.
    static func adaptive(minimum: CGFloat,
                         maximum: CGFloat) -> [Element] {
        [.adaptive(minimum: minimum,
                   maximum: maximum)]
    }
    
    /// 创建包含单个固定大小网格项的数组。/ Creates an array with a single fixed-size grid item.
    /// - Parameter size: 此网格项的固定大小。/ The fixed size for this grid item.
    /// - Returns: 包含单个固定大小GridItem的数组。/ An array containing a single fixed-size GridItem.
    static func fixed(_ size: CGFloat) -> [Element] {
        [.fixed(size)]
    }
    
    /// 创建固定大小网格项的数组。/ Creates an array of fixed-size grid items.
    /// - Parameter sizes: 每个网格项的尺寸数组。/ An array of sizes for each grid item.
    /// - Returns: 固定大小GridItem的数组。/ An array of fixed-size GridItems.
    static func fixed(_ sizes: [CGFloat]) -> [Element] {
        sizes.map { .fixed($0) }
    }
    
    /// 创建包含具有最小和最大约束的单个弹性网格项的数组。/ Creates an array with a single flexible grid item with minimum and maximum constraints.
    /// - Parameters:
    ///   - minimum: 此网格项的最小宽度。/ The minimum width for this grid item.
    ///   - maximum: 此网格项的最大宽度。/ The maximum width for this grid item.
    /// - Returns: 包含具有约束的单个弹性GridItem的数组。/ An array containing a single flexible GridItem with constraints.
    static func flexible(minimum: CGFloat,
                         maximum: CGFloat) -> [Element] {
        [.flexible(minimum: minimum,
                   maximum: maximum)]
    }
}