//
//  SwiftUIView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 9/12/24.
//

import SwiftUI

/// 空占位符视图修饰器/Empty placeholder view modifier
/// 当集合为空时显示占位符的视图修饰器。/View modifier that shows placeholder when collection is empty.
/// - Items: 集合类型/Collection type
/// - PlaceholderView: 占位符视图类型/Placeholder view type
struct EmptyPlaceholderModifier<Items: Collection, PlaceholderView: View>: ViewModifier {
    /// 集合/Collection
    let items: Items
    /// 占位符视图/Placeholder view
    let placeholder: PlaceholderView
    
    /// 构建视图/Build view
    /// - Parameter content: 内容视图/Content view
    /// - Returns: 应用修饰器的视图/View with modifier applied
    @ViewBuilder func body(content: Content) -> some View {
        content
            .overlay {
                if items.isEmpty {
                    placeholder
                }
            }
    }
}

/// 空占位符扩展/Empty placeholder extension
extension View {
    /// 添加空占位符/Add empty placeholder
    /// 当集合为空时显示占位符视图。/Shows placeholder view when collection is empty.
    /// - Parameters:
    ///   - items: 集合/Collection
    ///   - placeholder: 占位符视图构建闭包/Placeholder view builder closure
    /// - Returns: 应用修饰器的视图/View with modifier applied
    public func emptyPlaceholder<Items: Collection, PlaceholderView: View>(_ items: Items, _ placeholder: @escaping () -> PlaceholderView) -> some View {
        modifier(EmptyPlaceholderModifier(items: items, placeholder: placeholder()))
    }
}
