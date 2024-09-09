//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2024/9/6.
//

import SwiftUI
#if os(iOS)
import UIKit

public extension Brick where Wrapped: View {
    /**
     .confirmationDialog("", isPresented: $showActionSheet, titleVisibility: .hidden) {
         Button("Photo Library") {
             showPhotoLibrary.toggle()
         }
         
         Button("Camera") {
             showCamera.toggle()
         }
     }
     .ss.alertButtonTint(.white)
     
     .alert("Are you sure?",
       isPresented: $isPresentingAlert) {

         Button("Delete Account", role: .destructive) { }
         Button("Cancel", role: .cancel) { }
         
     } message: {
         Text("You are about to delete \(userInfo?.name ?? "") This action cannot be reversed.")
     }
     .ss.alertButtonTint(.white)
     */
    func alertButtonTint(color: Color) -> some View {
        wrapped.modifier(AlertButtonTintColor(color: color))
    }
}

struct AlertButtonTintColor: ViewModifier {
    let color: Color
    @State private var previousTintColor: UIColor?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                previousTintColor = UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor
                UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(color)
            }
            .onDisappear {
                UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = previousTintColor
            }
    }
}
#endif
