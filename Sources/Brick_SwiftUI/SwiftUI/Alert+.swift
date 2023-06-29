//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/29.
//

import SwiftUI

extension View {
    @available(iOS, introduced: 13.0, deprecated: 15.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(macOS, introduced: 10.15, deprecated: 12.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(tvOS, introduced: 13.0, deprecated: 15.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(watchOS, introduced: 6.0, deprecated: 8.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    public func alert(isPresented: Binding<Bool>, title: Text, message: Text?) -> some View {
        alert(isPresented: isPresented) {
            Alert(title: title, message: message)
        }
    }
    @available(iOS, introduced: 13.0, deprecated: 15.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(macOS, introduced: 10.15, deprecated: 12.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(tvOS, introduced: 13.0, deprecated: 15.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(watchOS, introduced: 6.0, deprecated: 8.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    public func alert(isPresented: Binding<Bool>, title: Text, message: Text?, primaryButton: Alert.Button, secondaryButton: Alert.Button) -> some View {
        alert(isPresented: isPresented) {
            Alert(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
    }
    @available(iOS, introduced: 13.0, deprecated: 15.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(macOS, introduced: 10.15, deprecated: 12.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(tvOS, introduced: 13.0, deprecated: 15.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    @available(watchOS, introduced: 6.0, deprecated: 8.0, message: "use `alert(title:isPresented:presenting::actions:) instead.")
    public func alert(isPresented: Binding<Bool>, title: Text, message: Text?, dismissButton: Alert.Button) -> some View {
        alert(isPresented: isPresented) {
            Alert(title: title, message: message, dismissButton: dismissButton)
        }
    }
}
