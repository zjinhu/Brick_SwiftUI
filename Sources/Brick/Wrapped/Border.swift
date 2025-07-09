//
//  SwiftUIView.swift
//
//
//  Created by 狄烨 on 2023/10/11.
//

import SwiftUI
@MainActor 
public extension Brick where Wrapped: View {
    @inlinable
    func border(_ borderColor: Color,
                cornerRadius: CGFloat,
                lineWidth: CGFloat) -> some View {
        wrapped.overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(borderColor, lineWidth: lineWidth)
        }
    }
    
    @inlinable
    func borderCapsule(_ borderColor: Color,
                       lineWidth: CGFloat) -> some View {
        wrapped.overlay {
            Capsule()
                .stroke(borderColor, lineWidth: lineWidth)
        }
    }
    
    @inlinable
    func border<Content: ShapeStyle>(_ content: Content,
                                     width: CGFloat = 1,
                                     cornerRadius: CGFloat = 0) -> some View {
        wrapped.overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(content, lineWidth: width)
        )
    }
}
