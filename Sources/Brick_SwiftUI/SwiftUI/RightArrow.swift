//
//  RightArrow.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

extension View {
    public func rightArrow() -> some View {
        HStack {
            self
            Spacer()
            Chevron()
        }
    }
}

struct Chevron: View {
    var body: some View {
        Image(systemName: .chevronRight)
            .foregroundColor(.secondary)
            .font(.callout.weight(.semibold))
    }
}
