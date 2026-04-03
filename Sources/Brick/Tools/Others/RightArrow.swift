//
//  RightArrow.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI
#if os(iOS)

/// 右侧箭头扩展/Right arrow extension
/// 为视图添加右侧箭头指示器。/Adds a right arrow indicator to a view.
extension View {
    /// 添加右侧箭头/Add right arrow
    /// - Parameters:
    ///   - color: 箭头颜色，默认.systemGray2/Arrow color, default .systemGray2
    ///   - font: 箭头字体，默认.footnote.semiBold/Arrow font, default .footnote.semibold
    ///   - showArrow: 是否显示箭头/Whether to show the arrow
    /// - Returns: 添加了箭头的视图/View with arrow added
    public func addRightArrow(color: Color = Color(.systemGray2),
                              font: Font = Font.footnote.weight(.semibold),
                              showArrow: Bool = true) -> some View {
        HStack {
            self
            if showArrow{
                Spacer()
                Chevron(color: color, font: font)
            }
        }
    }
}

/// V形箭头视图/Chevron arrow view
struct Chevron: View {
    @Environment(\.layoutDirection) var direction
    let color: Color
    let font: Font
    var body: some View {
        Image(symbol: direction == .rightToLeft ? .chevronLeft : .chevronRight)
            .foregroundColor(color)
            .font(font)
    }
}
#endif
