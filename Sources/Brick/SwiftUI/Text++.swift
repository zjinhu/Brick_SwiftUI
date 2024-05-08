//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI

extension Text {
    /// Applies a linear foreground gradient to the text.
    public func foregroundLinearGradient(
        _ gradient: Gradient,
        startPoint: UnitPoint = .leading,
        endPoint: UnitPoint = .trailing
    ) -> some View {
        overlay(
            LinearGradient(
                gradient: gradient,
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
        .mask(self)
    }
    
    public func autoFontSize(minimumScaleFactor: CGFloat = 0.01) -> some View {
        lineLimit(1)
        .minimumScaleFactor(minimumScaleFactor)
    }
    
}
