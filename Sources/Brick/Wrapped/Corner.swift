//
//  Corner++.swift
//  SwiftBrick
//
//  Created by iOS on 2023/5/23.
//

import SwiftUI
#if os(iOS)

public extension Brick where Wrapped: View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        wrapped.clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
#endif
