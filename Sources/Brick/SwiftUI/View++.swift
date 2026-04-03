//
//  View++.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  View 扩展 - 提供 View 的通用功能扩展 / View extension - provides common View functionality extensions
//

import SwiftUI

// MARK: - View.then
/// View then 扩展 / View then extension
/// 允许在闭包中修改 View 属性 / Allows modifying View properties in closure
extension View {
    @inlinable
    public func then(_ body: (inout Self) -> Void) -> Self {
        var result = self
        
        body(&result)
        
        return result
    }
}

// MARK: - View.overlay
/// View overlay 扩展 / View overlay extension
extension View {
    @_disfavoredOverload
    @inlinable
    public func overlay<Overlay: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ overlay: () -> Overlay
    ) -> some View {
        self.overlay(overlay(), alignment: alignment)
    }
}

/// 条件隐藏视图 / Hides view conditionally
extension View {
    /// 条件隐藏视图 / Hides view conditionally
    /// - Parameter isHidden: 是否隐藏 / Whether to hide
    @_disfavoredOverload
    @inlinable
    public func hidden(_ isHidden: Bool) -> some View {
        PassthroughView {
            if isHidden {
                hidden()
            } else {
                self
            }
        }
        .eraseToAnyView()
    }
}

// MARK: View.offset
/// View offset 扩展 / View offset extension
extension View {
    /// 内嵌偏移 (反向偏移) / Inset offset (reverse offset)
    /// - Parameter point: 偏移点 / Offset point
    @inlinable
    public func inset(_ point: CGPoint) -> some View {
        offset(x: -point.x, y: -point.y)
    }
    
    /// 内嵌偏移 (反向偏移) / Inset offset (reverse offset)
    /// - Parameter length: 偏移长度 / Offset length
    @inlinable
    public func inset(_ length: CGFloat) -> some View {
        offset(x: -length, y: -length)
    }
    
    /// 从 CGPoint 偏移 / Offset from CGPoint
    /// - Parameter point: 偏移点 / Offset point
    @inlinable
    public func offset(_ point: CGPoint) -> some View {
        offset(x: point.x, y: point.y)
    }
    
    /// 从长度偏移 / Offset from length
    /// - Parameter length: 偏移长度 / Offset length
    @inlinable
    public func offset(_ length: CGFloat) -> some View {
        offset(x: length, y: length)
    }
}

// MARK: - View.transition
/// View transition 扩展 / View transition extension
extension View {
    /// 关联过渡效果 / Associates a transition with the view
    /// - Parameter makeTransition: 过渡构建闭包 / Transition building closure
    public func transition(_ makeTransition: () -> AnyTransition) -> some View {
        self.transition(makeTransition())
    }
    
    /// 非对称过渡 - 仅插入 / Asymmetric transition - insertion only
    /// - Parameter insertion: 插入过渡 / Insertion transition
    public func asymmetricTransition(
        insertion: AnyTransition
    ) -> some View {
        transition(.asymmetric(insertion: insertion, removal: .identity))
    }

    /// 非对称过渡 - 仅移除 / Asymmetric transition - removal only
    /// - Parameter removal: 移除过渡 / Removal transition
    public func asymmetricTransition(
        removal: AnyTransition
    ) -> some View {
        transition(.asymmetric(insertion: .identity, removal: removal))
    }
    
    /// 非对称过渡 - 插入和移除 / Asymmetric transition - insertion and removal
    /// - Parameters:
    ///   - insertion: 插入过渡 / Insertion transition
    ///   - removal: 移除过渡 / Removal transition
    public func asymmetricTransition(
        insertion: AnyTransition,
        removal: AnyTransition
    ) -> some View {
        transition(.asymmetric(insertion: insertion, removal: removal))
    }
}

/// 类型擦除扩展 / Type erasure extension
extension View {
    /// 返回类型擦除版本的视图 / Returns a type-erased version of `self`
    @inlinable
    public func eraseToAnyView() -> AnyView {
        return .init(self)
    }
}

public extension View {
    
    /// 将视图包装为 AnyView / Wrap the view in an `AnyView`
    /// - Warning: 不要滥用 AnyView，会影响视图标识 / Do not misuse AnyView. It messes up view identity
    /// - Returns: AnyView 包装 / AnyView wrapper
    func any() -> AnyView {
        AnyView(self)
    }
}

// MARK: - View.padding
// MARK: - View tap gesture

/// 视图点击手势扩展 / View tap gesture extension
extension View {
    
    /// 条件禁用点击手势 / Disabled tap gesture conditionally
    /// - Parameters:
    ///   - count: 点击次数 / Tap count
    ///   - disabled: 是否禁用 / Whether disabled
    ///   - perform: 点击回调 / Tap callback
    @available(tvOS 16.0, *)
    public func onTapGesture(
        count: Int = 1,
        disabled: Bool,
        perform: @escaping () -> Void
    ) -> some View {
        gesture(
            TapGesture(count: count).onEnded(perform),
            including: disabled ? .subviews : .all
        )
    }
    
    /// 背景点击手势 / Tap gesture on background
    @available(tvOS 16.0, *)
    public func onTapGestureOnBackground(
        count: Int = 1,
        perform action: @escaping () -> Void
    ) -> some View {
        background {
            Color.almostClear
                .contentShape(Rectangle())
                .onTapGesture(count: count, perform: action)
        }
    }
}

/// View fill 扩展 / View fill extension
extension View {
    
    /// 填充父视图 (相对尺寸) / Fill parent view (relative size)
    /// - Parameter alignment: 对齐方式 / Alignment
    @inlinable
    public func fill(alignment: Alignment = .center) -> some View {
        relativeSize(width: 1.0, height: 1.0, alignment: alignment)
    }
}

/// View fit 扩展 / View fit extension
extension View {
    
    /// 适应父视图 (保持宽高比) / Fit parent view (maintain aspect ratio)
    @inlinable
    public func fit() -> some View {
        GeometryReader { geometry in
            self.frame(
                width: geometry.size.minimumDimensionLength,
                height: geometry.size.minimumDimensionLength
            )
        }
    }
}

/// 环境值扩展 - 着色颜色 / Environment values extension - tint color
extension EnvironmentValues {
    private struct TintColor: EnvironmentKey {
        static let defaultValue: Color? = nil
    }
    
    /// 着色颜色 / Tint color
    public var tintColor: Color? {
        get {self[TintColor.self]}
        set {self[TintColor.self] = newValue}
    }
}

/// View 着色颜色扩展 / View tint color extension
extension View {
    /// 设置视图元素的着色颜色 / Sets the tint color of the elements displayed by this view
    /// - Parameter color: 颜色 / Color
    @ViewBuilder
    public func tintColor(_ color: Color?) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            self.tint(color).environment(\.tintColor, color)
        } else {
            self.environment(\.tintColor, color)
        }

    }
}

// MARK: - hideKeyboard / 隐藏键盘

#if os(iOS)
import UIKit
import SwiftUI

/// View 隐藏键盘扩展 / View hide keyboard extension
public extension View {
    /// 隐藏键盘 / Hide keyboard
    func hideKeyboard() {
        let app = UIApplication.shared
        let sel = #selector(UIResponder.resignFirstResponder)
        app.sendAction(sel, to: nil, from: nil, for: nil)
    }
}
#endif
