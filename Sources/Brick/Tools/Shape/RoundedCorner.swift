//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2024/9/2.
//  圆角矩形形状/Rounded corner shape
//  可指定特定角的圆角/Specifies rounding for specific corners

#if os(iOS)
import SwiftUI
import UIKit

/// 圆角矩形形状/Rounded corner shape
/// iOS平台可用/Available on iOS platform
public struct RoundedCorner: Shape {
    
    /// 圆角半径/Corner radius
    public var radius: CGFloat = .infinity
    /// 要应用圆角的角落/Corners to apply radius
    public var corners: UIRectCorner = .allCorners
    
    /// 初始化圆角矩形/Initialize rounded corner
    /// - Parameters:
    ///   - radius: 圆角半径/Corner radius
    ///   - corners: 要应用圆角的角落/Corners to apply radius (UIRectCorner)
    public init(radius: CGFloat, corners: UIRectCorner) {
        self.radius = radius
        self.corners = corners
    }
    
    /// 实现Shape协议的path方法/Implement path method of Shape protocol
    /// - Parameter rect: 边界矩形/Bounding rectangle
    /// - Returns: 圆角矩形路径/Rounded corner path
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
#endif
