//
//  SwiftUIView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 10/17/24.
//

import SwiftUI
#if os(iOS)
import UIKit
public extension Brick where Wrapped: View {
    
    func listSectionSpace(_ space: CGFloat) -> some View {
        if #available(iOS 17, *) {
            return wrapped
                .listSectionSpacing(space)
        } else {
            UITableView.appearance().sectionFooterHeight = space
            return wrapped
        }
        
    }
}
#endif
