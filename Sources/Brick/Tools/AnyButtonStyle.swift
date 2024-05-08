//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI

/// A type-erased wrapper for `ButtonStyle.`
public struct AnyButtonStyle: ButtonStyle {
    public let _makeBody: (Configuration) -> AnyView
    
    public init<V: View>(
        makeBody: @escaping (Configuration) -> V
    ) {
        self._makeBody = { makeBody($0).eraseToAnyView() }
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        self._makeBody(configuration)
    }
}

extension View {
    @_disfavoredOverload
    public func buttonStyle<V: View>(
        @ViewBuilder makeBody: @escaping (AnyButtonStyle.Configuration) -> V
    ) -> some View {
        buttonStyle(AnyButtonStyle(makeBody: makeBody))
    }
}
