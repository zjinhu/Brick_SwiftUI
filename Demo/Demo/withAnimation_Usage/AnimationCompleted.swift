//
//  AnimationCompleted.swift
//  Example
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI
import BrickKit
@available(tvOS 16.0, *)
struct AnimationCompleted: View {
    @State private var introTextOpacity = 0.0
    @State private var value = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("withAnimation")
                .scaleEffect(value ? 2 : 1)
                .onTapGesture {
                    
                    withAnimation(.easeOut(duration: 3), after: 3) {
                        value.toggle()
                    } completion: {
                        
                        logger.log("Animation have finished")
                    }
                }
            
            Text("onAnimationCompleted")
                .opacity(introTextOpacity)
                .onAnimationCompleted(for: introTextOpacity) {
                    print("onAnimationCompleted")
                }
        }.onAppear(perform: {
            withAnimation(.easeIn(duration: 3.0)) {
                introTextOpacity = 1.0
            }
        })
#if os(iOS)
        .ss.tabBar(.hidden)
#endif
    }
}
@available(tvOS 16.0, *)
struct AnimationCompleted_Previews: PreviewProvider {
    static var previews: some View {
        AnimationCompleted()
    }
}
