//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI

/// 任意按钮样式/Any button style
/// 类型擦除的ButtonStyle包装器。/A type-erased wrapper for `ButtonStyle`.
public struct AnyButtonStyle: ButtonStyle {
    /// 构建闭包/Make body closure
    public let _makeBody: (Configuration) -> AnyView
    
    /// 初始化任意按钮样式/Initialize any button style
    /// - Parameter makeBody: 构建视图闭包/Make body view closure
    public init<V: View>(
        makeBody: @escaping (Configuration) -> V
    ) {
        self._makeBody = { makeBody($0).eraseToAnyView() }
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        self._makeBody(configuration)
    }
}

/// View扩展/View extension
extension View {
    /// 使用闭包设置按钮样式/Set button style with closure
    @_disfavoredOverload
    public func buttonStyle<V: View>(
        @ViewBuilder makeBody: @escaping (AnyButtonStyle.Configuration) -> V
    ) -> some View {
        buttonStyle(AnyButtonStyle(makeBody: makeBody))
    }
}
