//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2024/9/2.
//
#if os(iOS)
import SwiftUI
import UIKit
public struct RoundedCorner: Shape {
    
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners
    
    public init(radius: CGFloat, corners: UIRectCorner) {
        self.radius = radius
        self.corners = corners
    }
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
#endif
