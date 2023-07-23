//
//  Utilities.swift
//  Refresh_SwiftUI
//
//  Created by iOS on 2023/5/9.
//

import SwiftUI
extension View {
    
    func clipped(_ value: Bool) -> some View {
        if value {
            return AnyView(self.clipped())
        } else {
            return AnyView(self)
        }
    }
}

extension EdgeInsets {
    
    static var zero: EdgeInsets {
        .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}
