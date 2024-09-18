//
//  ObservableScrollView.swift
//  MetagAI
//
//  Created by iOS on 2024/8/28.
//

import SwiftUI

public struct ScrollTrackingView<Content: View>: View {
    @Binding var currentScroll: CGFloat
 
    let contentViews: () -> Content
    
    init(currentScroll: Binding<CGFloat>,
         contentViews: @escaping () -> Content) {
        self._currentScroll = currentScroll
        self.contentViews = contentViews
    }
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            GeometryReader { geometry in
                Color.clear.preference(key: ScrollPreferenceKey.self, value: geometry.frame(in: .named("ScrollTrackingView")).minY)
            }
            contentViews()
        }
        .coordinateSpace(name: "ScrollTrackingView")
        .onScroll { offset in
            updateCurrentScroll(offset)
        }
    }
    
    private func updateCurrentScroll(_ offset: CGFloat) {
        currentScroll += offset
    }
}

struct ScrollPreferenceKey: PreferenceKey {
    static let defaultValue = CGFloat.zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

extension View {
    func onScroll(offset: @escaping (CGFloat) -> Void) -> some View {
        onPreferenceChange(ScrollPreferenceKey.self) { offsetValue in
            offset(offsetValue)
        }
    }
}
