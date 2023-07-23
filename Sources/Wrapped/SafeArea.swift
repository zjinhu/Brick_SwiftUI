//
//  SafeArea.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

public extension Brick where Wrapped: View {

    @inlinable
    func safeAreaPadding(_ edgeInsets: EdgeInsets) -> some View {
        wrapped.modifier(SafeAreaPaddingModifier(edgeInsets))
    }

    @inlinable
    func safeAreaPadding(_ length: CGFloat = 16) -> some View {
        wrapped.modifier(SafeAreaPaddingModifier(length))
    }

    @inlinable
    func safeAreaPadding(_ edges: Edge.Set, _ length: CGFloat = 16) -> some View {
        wrapped.modifier(SafeAreaPaddingModifier(edges, length))
    }
}

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

