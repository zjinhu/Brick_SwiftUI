//
//  SafeArea.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI
@frozen
public struct SafeAreaPaddingModifier: ViewModifier {
    public var edgeInsets: EdgeInsets

    @inlinable
    public init(_ edgeInsets: EdgeInsets) {
        self.edgeInsets = edgeInsets
    }

    @inlinable
    public init(_ length: CGFloat = 16) {
        self.init(EdgeInsets(top: length, leading: length, bottom: length, trailing: length))
    }

    @inlinable
    public init(_ edges: Edge.Set, _ length: CGFloat = 16) {
        let edgeInsets = EdgeInsets(
            top: edges.contains(.top) ? length : 0,
            leading: edges.contains(.leading) ? length : 0,
            bottom: edges.contains(.bottom) ? length : 0,
            trailing: edges.contains(.trailing) ? length : 0
        )
        self.init(edgeInsets)
    }

    public func body(content: Content) -> some View {
        content
            ._safeAreaInsets(edgeInsets)
    }
}

extension View {

    /// A modifier that adds additional safe area padding
    /// to the edges of a view.
    @inlinable
    public func safeAreaPadding(_ edgeInsets: EdgeInsets) -> some View {
        modifier(SafeAreaPaddingModifier(edgeInsets))
    }

    /// A modifier that adds additional safe area padding
    /// to the edges of a view.
    @inlinable
    public func safeAreaPadding(_ length: CGFloat = 16) -> some View {
        modifier(SafeAreaPaddingModifier(length))
    }

    /// A modifier that adds additional safe area padding
    /// to the edges of a view.
    @inlinable
    public func safeAreaPadding(_ edges: Edge.Set, _ length: CGFloat = 16) -> some View {
        modifier(SafeAreaPaddingModifier(edges, length))
    }
}

struct SafeAreaPaddingModifier_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
                .safeAreaPadding(24)

            Color.blue
                .safeAreaPadding(24)
                .ignoresSafeArea()

            Color.yellow
                .safeAreaPadding(24)
        }
    }
}
