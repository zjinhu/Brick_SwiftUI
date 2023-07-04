//
//  RightArrow.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

extension View {
    public func rightArrow(color: Color = Color(.systemGray2),
                           font: Font = Font.footnote.weight(.semibold)) -> some View {
        HStack {
            self
            Spacer()
            Chevron(color: color, font: font)
        }
    }
}

struct Chevron: View {
    let color: Color
    let font: Font
    var body: some View {
        Image(symbol: .chevronRight)
            .foregroundColor(color)
            .font(font)
    }
}
