//
//  ToastTextView.swift
//  Toast
//
//  Created by iOS on 2023/5/4.
//  消息视图组件/Message view component
//  简单的文本消息Toast视图/Simple text message Toast view

import SwiftUI

/// 消息视图/Message view
struct MessageView: View {
    /// 消息文本/Message text
    var text: String
    
    var body: some View {
        Text(text)
            .padding(10)
            .foregroundColor(.white)
            .background(
                Color.black
                    .opacity(0.8)
                    .cornerRadius(10)
            )
    }
}

/// 消息视图预览/Message view preview
struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(text: "xxxx")
            .background(Color.black
                .opacity(0.8)
                .cornerRadius(8)
            )
    }
}
