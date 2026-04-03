//
//  ListSpace.swift
//  Brick_SwiftUI
//
//  List 分组间距
//  List section spacing
//  设置 List 分组间距 (iOS 17+ 使用原生 API)
//  Set List section spacing (iOS 17+ uses native API)
//
//  Created by iOS on 10/17/24.
//

import SwiftUI
#if os(iOS)
import UIKit

/// Brick 扩展：List 分组间距
/// Brick extension: List section spacing
public extension Brick where Wrapped: View {
    /// 设置 List 分组间距
    /// Set List section spacing
    /// - Parameter space: 间距大小 / Spacing
    /// - Returns: 修改后的 View / Modified View
    @MainActor func listSectionSpace(_ space: CGFloat) -> some View {
        if #available(iOS 17, *) {
            return wrapped
                .listSectionSpacing(space)
        } else {
            UITableView.appearance().sectionFooterHeight = space
            return wrapped
        }
        
    }
}
#endif
