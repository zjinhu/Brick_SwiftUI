//
//  Hidden.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

@frozen
public struct HiddenModifier: ViewModifier {
    public var isHidden: Bool

    @inlinable
    public init(isHidden: Bool) {
        self.isHidden = isHidden
    }

    public func body(content: Content) -> some View {
        if isHidden {
            content.hidden()
        } else {
            content
        }
    }
}

extension View {

    /// A modifier that conditionally hides a view
    @inlinable
    public func hidden(_ isHidden: Bool) -> some View {
        modifier(HiddenModifier(isHidden: isHidden))
    }
}
