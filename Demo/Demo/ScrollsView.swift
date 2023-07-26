//
//  ScrollsView.swift
//  Example
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI
import Brick_SwiftUI
struct ScrollsView: View {
    @State private var indicatorVisibility: Brick.ScrollIndicatorVisibility = .automatic
    @State private var dismissMode: Brick.ScrollDismissesKeyboardMode = .automatic
    @State private var scrollEnabled: Bool = true
    var body: some View {
        VScrollStack{
            Toggle("Scroll Enabled", isOn: $scrollEnabled)
            
            HStack {
                Text("Scroll Indicators")
                Spacer()
                Picker("", selection: $indicatorVisibility) {
                    ForEach(Brick.ScrollIndicatorVisibility.all, id: \.self) { value in
                        Text(String(describing: value))
                            .tag(value)
                    }
                }
            }
            
            Section {
                HStack {
                    Text("Dismiss Mode")
                    Spacer()
                    Picker("", selection: $dismissMode) {
                        ForEach(Brick.ScrollDismissesKeyboardMode.all, id: \.self) { value in
                            Text(String(describing: value))
                                .tag(value)
                        }
                    }
                }

                TextField("Placeholder", text: .constant(""))
            }
 
            Spacer()
        }
        .ss.safeAreaPadding(.all)
        .ss.scrollDismissesKeyboard(dismissMode)
        .ss.scrollIndicators(indicatorVisibility)
        .ss.scrollDisabled(!scrollEnabled)
#if !os(xrOS) && os(iOS)
        .ss.tabBar(.hidden)
#endif
    }
}

struct ScrollsView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollsView()
    }
}


extension Brick.ScrollIndicatorVisibility {
    static var all: [Self] {
        [.automatic, .visible, .hidden]
    }
}

extension Brick.ScrollDismissesKeyboardMode {
    static var all: [Self] {
        [.automatic, .immediately, .interactively]
    }
}
