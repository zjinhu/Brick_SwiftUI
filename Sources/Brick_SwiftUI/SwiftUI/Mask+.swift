//
//  Mask+.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

extension View {
 
    @inlinable
    public func invertedMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder mask: () -> Mask
    ) -> some View {
        self.mask(
            Rectangle()
                .scale(100)
                .ignoresSafeArea()
                .overlay(
                    mask()
                        .blendMode(.destinationOut),
                    alignment: alignment
                )
        )
    }
}
