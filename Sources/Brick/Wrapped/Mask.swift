//
//  Mask+.swift
//  Brick_SwiftUI
//
//  反向蒙版
//  Inverted mask
//  反向蒙版，用于徽章效果
//  Inverted mask for badge effects
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

/// Brick 扩展：反向蒙版
/// Brick extension: Inverted mask
public extension Brick where Wrapped: View {
    /// 添加反向蒙版
    /// Add inverted mask
    /// - Parameters:
    ///   - alignment: 对齐方式 / Alignment
    ///   - mask: 蒙版构建器 / Mask builder
    /// - Returns: 修改后的 View / Modified View
    @inlinable
    func invertedMask<Mask: View>(alignment: Alignment = .center,
                                  @ViewBuilder mask: () -> Mask) -> some View {
        wrapped.mask(
            Rectangle()
                    .scale(100)
                    .ignoresSafeArea()
                    .overlay(
                        mask()
                            .blendMode(.destinationOut),
                        alignment: alignment
                    )
            )
    }
}
