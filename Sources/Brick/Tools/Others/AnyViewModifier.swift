//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/28.
//

import Swift
import SwiftUI

/// 类型擦除的视图修饰器/Type-erased view modifier
/// 将任意ViewModifier包装为类型擦除的形式。/Wraps any ViewModifier into a type-erased form.
public struct AnyViewModifier: ViewModifier {
    private let makeBody: (Content) -> AnyView

    /// 使用ViewModifier初始化/Initialize with ViewModifier
    /// - Parameter modifier: 要包装的修饰器/Modifier to wrap
    public init<T: ViewModifier>(_ modifier: T) {
        self.makeBody = { $0.modifier(modifier).eraseToAnyView() }
    }

    /// 使用闭包初始化/Initialize with closure
    /// - Parameter makeBody: 构建视图闭包/Make body view closure
    public init<Body: View>(
        @ViewBuilder _ makeBody: @escaping (Content) -> Body
    ) {
        self.makeBody = { makeBody($0).eraseToAnyView() }
    }

    public func body(content: Content) -> some View {
        makeBody(content)
    }
}
