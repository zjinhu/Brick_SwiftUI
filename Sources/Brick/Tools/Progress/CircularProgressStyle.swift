//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2024/9/2.
//

import SwiftUI

public struct CircularProgressStyle: ProgressViewStyle {
    public var strokeColor: Color = .blue
    public var strokeWidth: CGFloat = 10.0
    
    public init(strokeColor: Color, strokeWidth: CGFloat) {
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .stroke(strokeColor.opacity(0.3), lineWidth: strokeWidth)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: configuration.fractionCompleted)
        }
    }
}
