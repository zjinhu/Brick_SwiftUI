//
//  TextEditorStyle.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2023-05-23.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//  TextEditor样式扩展/TextEditor style extension
//  提供多种TextEditor样式选择/Provides multiple TextEditor style options

#if os(iOS) || os(macOS)
import SwiftUI

/**
 TextEditor样式枚举/This enum defines various `TextEditor` styles.
 */
public enum TextEditorStyle {

    /// 标准无边框样式/The standard, borderless style.
    case automatic

    /// 标准无边框样式/The standard, borderless style.
    case plain

    /// 圆角边框样式/A rounded border style.
    case roundedBorder

    /// 圆角边框样式（自定义颜色）/A rounded border style with a custom color.
    /// - Parameters:
    ///   - Color: 边框颜色/Border color
    ///   - Double: 边框宽度/Border width
    case roundedColorBorder(Color, Double = 0.5)
}

/// TextEditor扩展/TextEditor extension
public extension TextEditor {

    /// 应用TextEditorStyle/Apply a ``TextEditorStyle`` to a text editor.
    ///
    /// 由于修饰器的工作方式，必须直接应用于TextEditor/Due to how the modifier works, it must be applied to the `TextEditor` directly.
    ///
    /// - Parameter style: 要应用的样式/The style to apply
    /// - Returns: 应用了样式的视图/View with style applied
    @ViewBuilder
    func textEditorStyle(_ style: TextEditorStyle) -> some View {
        switch style {
        case .automatic, .plain:
            self
        case .roundedBorder:
            self.cornerRadius(cornerRadius)
                .overlay(stroke(Color.primary.opacity(0.17)))
        case .roundedColorBorder(let color, let width):
            self.cornerRadius(cornerRadius)
                .overlay(stroke(color, lineWidth: width))
        }
    }
}

/// TextEditor私有扩展/TextEditor private extension
private extension TextEditor {
    
    /// 圆角半径/Corner radius
    var cornerRadius: Double { 5.0 }

    /// 描边边框/Stroke border
    /// - Parameters:
    ///   - color: 边框颜色/Border color
    ///   - lineWidth: 线条宽度/Line width
    /// - Returns: 带有描边的视图/View with stroke
    func stroke(
        _ color: Color,
        lineWidth: CGFloat = 0.5
    ) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(color, lineWidth: lineWidth)
    }
}

#Preview {
    
    struct Preview: View {
        
        @State
        var text: String = "Hello, world"
        
        var body: some View {
            VStack {
                TextField("", text: $text)
                    .textFieldStyle(.roundedBorder)
                TextEditor(text: $text)
                    .textEditorStyle(.roundedBorder)
                TextEditor(text: $text)
                    .textEditorStyle(.roundedColorBorder(.red, 5))
            }
            .padding(10)
            .background(Color.primary.colorInvert())
            // .environment(\.colorScheme, .dark)
        }
    }
    
    return Preview()
}
#endif

