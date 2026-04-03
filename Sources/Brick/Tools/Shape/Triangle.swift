//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2024/9/2.
//  三角形形状/Triangle shape
//  可创建向上或向下的三角形/Creates upward or downward triangles

import SwiftUI

/// 三角形形状/Triangle shape
public struct Triangle: Shape {
    /// 是否倒置/Whether inverted (pointing down)
    let inverted: Bool
    
    /// 初始化三角形/Initialize triangle
    /// - Parameter inverted: 是否倒置，默认为false（向上）/Whether inverted, default false (pointing up)
    public init(inverted: Bool = false) {
        self.inverted = inverted
    }
    
    /// 实现Shape协议的path方法/Implement path method of Shape protocol
    /// - Parameter rect: 边界矩形/Bounding rectangle
    /// - Returns: 三角形路径/Triangle path
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if inverted {
            // 倒置三角形（向下）/Inverted triangle (pointing down)
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        } else {
            // 正向三角形（向上）/Normal triangle (pointing up)
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
        
        path.closeSubpath()
        
        return path
    }
}
