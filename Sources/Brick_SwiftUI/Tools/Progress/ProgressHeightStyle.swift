//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/25.
//

import SwiftUI

extension ProgressViewStyle where Self == BarProgressViewStyle {
    static func bar(barHeight: CGFloat = 6,
                        foregroundColor: Color = .accentColor,
                        backgroundColor: Color = .gray.opacity(0.3)) -> BarProgressViewStyle {
        BarProgressViewStyle(barHeight: barHeight,
                             foregroundColor: foregroundColor,
                             backgroundColor: backgroundColor)
    }
}

public struct BarProgressViewStyle: ProgressViewStyle {
    
    private let foregroundColor: Color
    private let backgroundColor: Color
    private let barHeight: CGFloat
    
    public init( barHeight: CGFloat,
                 foregroundColor: Color,
                 backgroundColor: Color) {
        self.barHeight = barHeight
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0
        return GeometryReader { proxy in
            
            ZStack(alignment: .leading) {
                Capsule()
                    .foregroundColor(backgroundColor)
                Capsule()
                    .foregroundColor(foregroundColor)
                    .frame(width: proxy.size.width * CGFloat(progress), alignment: .leading)
                    .animation(.easeInOut, value: 0.7)
            }
        }
        .frame(height: barHeight, alignment: .leading)
    }
}
