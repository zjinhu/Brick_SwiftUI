//
//  BlurView.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

#if os(macOS)
import AppKit
struct BlurView: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSVisualEffectView {
        let view = NSVisualEffectView()
//        view.material = .sidebar
//        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        
    }
}
#elseif os(iOS)
import UIKit
struct BlurView: UIViewRepresentable {
   typealias UIViewType = UIVisualEffectView
   
   func makeUIView(context: Context) -> UIVisualEffectView {
       return UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
   }
   
   func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
       uiView.effect = UIBlurEffect(style: .systemMaterial)
   }
}

#endif
