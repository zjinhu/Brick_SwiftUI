//
//  BlurView.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
   typealias UIViewType = UIVisualEffectView
   
   func makeUIView(context: Context) -> UIVisualEffectView {
       return UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
   }
   
   func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
       uiView.effect = UIBlurEffect(style: .systemMaterial)
   }
}

