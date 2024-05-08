//
//  SwiftUIView.swift
//
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI

public extension View {
    /// Enable the view is a certain condition is met.
    /// This is just an inverted version of `disabled`. It's
    /// intended to increase readability.
    func enabled(_ condition: Bool) -> some View {
        disabled(!condition)
    }
    
    /// Hide the view if the provided condition is `true`.
    @ViewBuilder
    func hidden(if condition: Bool) -> some View {
        if condition {
            self.hidden()
        } else {
            self
        }
    }
    
    /// Show the view if the provided condition is `true`.
    func visible(if condition: Bool) -> some View {
        hidden(if: !condition)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    /// Make the view searchable if the condition is `true`.
    @ViewBuilder
    func searchable(if condition: Bool,
                    text: Binding<String>,
                    placement: SearchFieldPlacement = .automatic,
                    prompt: String) -> some View {
        if condition {
            self.searchable(
                text: text,
                placement: placement,
                prompt: prompt)
        } else {
            self
        }
    }
}
