//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2024/8/23.
//

import SwiftUI
#if os(iOS)
public struct GlassBlurView: UIViewRepresentable {
    public var removeAllFilters: Bool = false
    
    public init(removeAllFilters: Bool) {
        self.removeAllFilters = removeAllFilters
    }
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        GlassBlur(removeAllFilters: removeAllFilters)
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
}
 
class GlassBlur: UIVisualEffectView {
    init(removeAllFilters: Bool) {
        super.init(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        if subviews.indices.contains(1) {
            subviews[1].alpha = 0
        }
        if let backdropLayer = layer.sublayers?.first {
            if removeAllFilters {
                backdropLayer.filters = []
            } else {
                backdropLayer.filters?.removeAll(where: { filter in
                    String(describing: filter) != "gaussianBlur"
                })
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

/***
 Rectangle()
     .fill(Color.clear)
     .background{
         GlassBlurView(removeAllFilters: true)
             .blur(radius: 5, opaque: true)
             .background(.black.opacity(0.8))
     }
     .frame(height: 180)
 */
#endif
