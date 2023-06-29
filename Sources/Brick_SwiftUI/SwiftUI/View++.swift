//
// Copyright (c) Vatsal Manot
//

import SwiftUI

// MARK: - View.overlay
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

extension View {
    /// Hides this view conditionally.
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
extension View {
    @inlinable
    public func inset(_ point: CGPoint) -> some View {
        offset(x: -point.x, y: -point.y)
    }
    
    @inlinable
    public func inset(_ length: CGFloat) -> some View {
        offset(x: -length, y: -length)
    }
    
    @inlinable
    public func offset(_ point: CGPoint) -> some View {
        offset(x: point.x, y: point.y)
    }
    
    @inlinable
    public func offset(_ length: CGFloat) -> some View {
        offset(x: length, y: length)
    }
}

// MARK: - View.transition
extension View {
    /// Associates a transition with the view.
    public func transition(_ makeTransition: () -> AnyTransition) -> some View {
        self.transition(makeTransition())
    }
    
    /// Associates an insertion transition and a removal transition with the view.
    public func asymmetricTransition(
        insertion: AnyTransition = .identity,
        removal: AnyTransition = .identity
    ) -> some View {
        transition(.asymmetric(insertion: insertion, removal: removal))
    }
}

extension View {
    /// Returns a type-erased version of `self`.
    @inlinable
    public func eraseToAnyView() -> AnyView {
        return .init(self)
    }
}

// MARK: - View.padding
extension View {
    /// A view that pads this view inside the specified edge insets with a system-calculated amount of padding and a color.
    @_disfavoredOverload
    @inlinable
    public func padding(_ color: Color) -> some View {
        padding().background(color)
    }
}

extension View {
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

extension View {
    
    @inlinable
    public func fill(alignment: Alignment = .center) -> some View {
        relativeSize(width: 1.0, height: 1.0, alignment: alignment)
    }
}

extension View {
    
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

extension EnvironmentValues {
    private struct TintColor: EnvironmentKey {
        static let defaultValue: Color? = nil
    }
    
    public var tintColor: Color? {
        get {self[TintColor.self]}
        set {self[TintColor.self] = newValue}
    }
}

extension View {
    /// Sets the tint color of the elements displayed by this view.
    @ViewBuilder
    public func tintColor(_ color: Color?) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            self.tint(color).environment(\.tintColor, color)
        } else {
            self.environment(\.tintColor, color)
        }
    }
}

#if os(iOS)
import UIKit
import SwiftUI

public extension View {
    func hideKeyboard() {
        let app = UIApplication.shared
        let sel = #selector(UIResponder.resignFirstResponder)
        app.sendAction(sel, to: nil, from: nil, for: nil)
    }
}
#endif
