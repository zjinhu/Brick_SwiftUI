//
//  View+Shadow.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-03-05.
//  视图阴影样式扩展 - 提供类型安全的阴影样式 / View shadow style extension - provides type-safe shadow styles
//  Copyright © 2020-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 阴影样式定义 / Shadow style definition
 允许强类型化指定阴影值 / Allows strong typing for shadow values

 你可以通过创建静态计算属性来指定自己的标准样式 / You can specify your own standard styles by creating static, calculated extension properties, for instance:
 
 ```swift
 extension ShadowStyle {
     static let badge = Self(
         color: Color.black.opacity(0.1),
         radius: 3,
         x: 0,
         y: 2
     )
 }
 ```

 使用方式: `.shadow(_ style:)` 修饰器 / Usage: `.shadow(_ style:)` modifier
 */
public struct ViewShadowStyle : Sendable{
    
    /// 初始化阴影样式 / Initialize shadow style
    /// - Parameters:
    ///   - color: 阴影颜色 / Shadow color
    ///   - radius: 模糊半径 / Blur radius
    ///   - x: X 偏移 / X offset
    ///   - y: Y 偏移 / Y offset
    public init(
        color: Color? = nil,
        radius: CGFloat = 0,
        x: CGFloat = 0,
        y: CGFloat = 0
    ) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
    
    public let color: Color?
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
}

@MainActor
public extension ViewShadowStyle {
    
    /// 无阴影 / No shadow
    static let none = ViewShadowStyle(color: .clear)
    
    /// 徽章阴影 - 附着在父视图上但略微分离的层 / Badge shadow - attached to parent but slightly separated layer
    static var badge = ViewShadowStyle(radius: 1, y: 1)
    
    /// 提升阴影 - 略微高于父视图的实心元素 / Elevated shadow - solid element elevated above parent view
    static var elevated = ViewShadowStyle(radius: 3, x: 0, y: 2)
    
    /// 贴纸阴影 - 附着在父视图上的薄贴纸 / Sticker shadow - thin sticker attached to parent view
    static var sticker = ViewShadowStyle(radius: 0, y: 1)
}

/// View 阴影扩展 / View shadow extension
public extension View {

    /// 应用 ViewShadowStyle 到视图 / Apply a ViewShadowStyle to the view
    /// - Parameter style: 阴影样式 / Shadow style
    /// - Returns: 带阴影的视图 / View with shadow
    @ViewBuilder
    func shadow(_ style: ViewShadowStyle) -> some View {
        if let color = style.color {
            shadow(
                color: color,
                radius: style.radius,
                x: style.x,
                y: style.y
            )
        } else {
            shadow(
                radius: style.radius,
                x: style.x,
                y: style.y
            )
        }
    }
}

#Preview {

    struct Preview: View {

        @State
        private var isItemElevated = false

        var item: some View {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .frame(width: 100, height: 100)
        }

        var body: some View {
            VStack(spacing: 20) {
                item.shadow(.none)
                item.shadow(.badge)
                item.shadow(.sticker)

                #if os(iOS)
                item.onTapGesture(perform: toggleElevated)
                    .shadow(isItemElevated ? .elevated : .badge)
                #endif

                item.shadow(.elevated)
            }
            .padding()
            .background(Color.gray.opacity(0.4))
        }

        func toggleElevated() {
            withAnimation {
                isItemElevated.toggle()
            }
        }
    }
    
    return Preview()
}
