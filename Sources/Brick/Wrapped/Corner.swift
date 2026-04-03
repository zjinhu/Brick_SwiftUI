//
//  Corner++.swift
//  SwiftBrick
//
//  特定圆角设置
//  Specific corner radius
//  使用 UIRectCorner 设置特定圆角
//  Set specific corners using UIRectCorner
//
//  Created by iOS on 2023/5/23.
//

import SwiftUI
#if os(iOS)

/// Brick 扩展：特定圆角
/// Brick extension: Specific corner radius
public extension Brick where Wrapped: View {
    /// 设置特定圆角
    /// Set specific corner radius
    /// - Parameters:
    ///   - radius: 圆角半径 / Corner radius
    ///   - corners: 要设置圆角的角落 / Corners to round
    /// - Returns: 修改后的 View / Modified View
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        wrapped.clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
#endif
