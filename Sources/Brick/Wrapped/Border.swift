//
//  SwiftUIView.swift
//
//
//  Created by 狄烨 on 2023/10/11.
//

import SwiftUI

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
}
