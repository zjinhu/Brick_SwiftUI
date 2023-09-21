//
//  Mask+.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

public extension Brick where Wrapped: View {
    @inlinable
    func invertedMask<Mask: View>(alignment: Alignment = .center,
                                  @ViewBuilder mask: () -> Mask) -> some View {
        wrapped.mask(
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
