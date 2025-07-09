//
//  BottomSafeArea.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/7.
//

import SwiftUI
/*
 ScrollView {

 }
 .ss.bottomSafeAreaInset(overlayContent)
 */
@MainActor
extension Brick where Wrapped: View {
    @ViewBuilder
    public func bottomSafeAreaInset<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            wrapped.safeAreaInset(edge: .bottom, spacing: 0, content: { content() })
        } else {
            wrapped.modifier(BottomInsetViewModifier(overlayContent: content()))
        }


    }
    
    @ViewBuilder
    public func bottomSafeAreaInset<OverlayContent: View>(_ overlayContent: OverlayContent) -> some View {
                    
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            wrapped.safeAreaInset(edge: .bottom, spacing: 0, content: { overlayContent })
        } else {
            wrapped.modifier(BottomInsetViewModifier(overlayContent: overlayContent))
        }


    }
}

struct BottomInsetViewModifier<OverlayContent: View>: ViewModifier {
    @Environment(\.bottomSafeAreaInset) var ancestorBottomSafeAreaInset: CGFloat
    var overlayContent: OverlayContent
    @State var overlayContentHeight: CGFloat = 0
    
    func body(content: Self.Content) -> some View {
        content
            .environment(\.bottomSafeAreaInset, overlayContentHeight + ancestorBottomSafeAreaInset)
            .overlay(
                overlayContent
                    .readHeight {
                        overlayContentHeight = $0
                    }
                    .padding(.bottom, ancestorBottomSafeAreaInset)
                ,
                alignment: .bottom
            )
    }
}

@MainActor
struct BottomSafeAreaInsetKey: @preconcurrency EnvironmentKey {
    static var defaultValue: CGFloat = 0
}

extension EnvironmentValues {
    var bottomSafeAreaInset: CGFloat {
        get { self[BottomSafeAreaInsetKey.self] }
        set { self[BottomSafeAreaInsetKey.self] = newValue }
    }
}

struct ExtraBottomSafeAreaInset: View {
    @Environment(\.bottomSafeAreaInset) var bottomSafeAreaInset: CGFloat
    
    var body: some View {
        Spacer(minLength: bottomSafeAreaInset)
    }
}
