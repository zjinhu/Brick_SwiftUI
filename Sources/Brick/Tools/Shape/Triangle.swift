//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2024/9/2.
//

import SwiftUI
// 创建三角形结构
public struct Triangle: Shape {
    let inverted: Bool
    
    public init(inverted: Bool = false) {
        self.inverted = inverted
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if inverted {
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        } else {
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
        
        path.closeSubpath()
        
        return path
    }
}
