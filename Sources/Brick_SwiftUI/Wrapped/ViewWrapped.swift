//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/29.
//

import SwiftUI

extension Brick where Wrapped: View {
    
    public func shadow(
        color: Color = .black,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat
    ) -> some View {
        wrapped.shadow(color: color, radius: blur / 2, x: x, y: y)
    }
}

extension Brick where Wrapped: View {
    
    public func border<Content: ShapeStyle>(
        _ content: Content,
        width: CGFloat = 1,
        cornerRadius: CGFloat = 0
    ) -> some View {
        wrapped.overlay(RoundedRectangle(cornerRadius: cornerRadius)
            .strokeBorder(content, lineWidth: width)
        )
    }
}
