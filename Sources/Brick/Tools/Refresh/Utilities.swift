//
//  Utilities.swift
//  Refresh_SwiftUI
//
//  Created by iOS on 2023/5/9.
//

import SwiftUI

// MARK: 视图裁剪扩展/View Clipping Extension
extension View {
    /// 条件裁剪视图/Conditionally clip view
    /// - Parameter value: 是否裁剪/Whether to clip
    /// - Returns: 裁剪后的视图/Clipped view
    func clipped(_ value: Bool) -> some View {
        if value {
            return AnyView(self.clipped())
        } else {
            return AnyView(self)
        }
    }
}

// MARK: 边距扩展/EdgeInsets Extension
extension EdgeInsets {
    /// 零边距/Zero insets
    static var zero: EdgeInsets {
        .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}
