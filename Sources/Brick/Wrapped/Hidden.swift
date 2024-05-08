//
//  Hidden.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

public extension Brick where Wrapped: View {

    @inlinable
    func hidden(_ isHidden: Bool,
                transition: AnyTransition = .identity) -> some View {
        wrapped.modifier(HiddenModifier(isHidden: isHidden,
                                        transition: transition))
    }
}

@frozen
public struct HiddenModifier: ViewModifier {
    
    public var isHidden: Bool

    public var transition: AnyTransition
    
    @inlinable
    public init(isHidden: Bool,
                transition: AnyTransition = .opacity) {
        self.isHidden = isHidden
        self.transition = transition
    }

    public func body(content: Content) -> some View {
        if isHidden {
            content
                .hidden()
        } else {
            content
                .transition(transition)
        }
    }
}
