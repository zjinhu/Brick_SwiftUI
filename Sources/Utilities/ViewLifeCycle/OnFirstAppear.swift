//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/7/11.
//

import SwiftUI
struct OnFirstAppear: ViewModifier {
    let action: (() -> Void)?
    
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content.onAppear {
            if !hasAppeared {
                hasAppeared = true
                action?()
            }
        }
    }
}
public extension View {
    func onFirstAppear(perform action: (() -> Void)? = nil) -> some View {
        modifier(OnFirstAppear(action: action))
    }
}
