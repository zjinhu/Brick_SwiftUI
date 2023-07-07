//
//  Corner++.swift
//  SwiftBrick
//
//  Created by iOS on 2023/5/23.
//

import SwiftUI
import UIKit
public extension Brick where Wrapped: View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        wrapped.clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

public struct RoundedCorner: Shape {
    
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
