//
//  Hidden.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

public extension Brick where Wrapped: View {

    @inlinable
    func hidden(_ isHidden: Bool) -> some View {
        wrapped.modifier(HiddenModifier(isHidden: isHidden))
    }
}

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
