//
//  RightArrow.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI
#if os(iOS)
extension View {
    public func addRightArrow(color: Color = Color(.systemGray2),
                           font: Font = Font.footnote.weight(.semibold)) -> some View {
        HStack {
            self
            Spacer()
            Chevron(color: color, font: font)
        }
    }
}

struct Chevron: View {
    @Environment(\.layoutDirection) var direction
    let color: Color
    let font: Font
    var body: some View {
        Image(symbol: direction == .rightToLeft ? .chevronLeft : .chevronRight)
            .foregroundColor(color)
            .font(font)
    }
}
#endif
