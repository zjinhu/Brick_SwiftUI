//
//  FontEx.swift
//  SwiftBrick
//
//  Created by iOS on 2023/5/9.
//  Copyright © 2023 狄烨 . All rights reserved.
//

import SwiftUI
 
extension Brick where Wrapped == Text {
    @inlinable
    public func font(_ font: Font, weight: Font.Weight?) -> Text {
        if let weight {
            return wrapped.font(font.weight(weight))
        } else {
            return wrapped.font(font)
        }
    }
}

extension Brick where Wrapped: View {
    @inlinable
    @ViewBuilder
    public func font(_ font: Font, weight: Font.Weight?) -> some View {
        if let weight {
            wrapped.font(font.weight(weight))
        } else {
            wrapped.font(font)
        }
    }
}
