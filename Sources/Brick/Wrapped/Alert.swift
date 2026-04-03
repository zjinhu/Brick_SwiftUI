//
//  Alert.swift
//  Brick_SwiftUI
//
//  警告对话框按钮色调
//  Alert button tint color
//  自定义 UIAlertController 按钮色调
//  Customize UIAlertController button tint color
//
//  Created by iOS on 2024/9/6.
//

import SwiftUI
#if os(iOS)
import UIKit

/// Brick 扩展：警告对话框按钮色调
/// Brick extension: Alert button tint color
public extension Brick where Wrapped: View {
    /// 设置警告对话框按钮色调
    /// Set alert button tint color
    /// - Parameter color: 按钮颜色 / Button color
    /// - Returns: 修改后的 View / Modified View
    /**
     使用示例 / Usage:
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
         Text("You are about to delete this account.")
     }
     .ss.alertButtonTint(.white)
     */
    func alertButtonTint(color: Color) -> some View {
        wrapped.modifier(AlertButtonTintColor(color: color))
    }
}

/// 警告按钮色调修饰器
/// Alert button tint color modifier
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
