//
//  TestView.swift
//  BrickBrickDemo
//
//  Created by iOS on 9/26/24.
//

import SwiftUI
import BrickKit
#if os(iOS)
struct TestView: View {
    @Environment(\.dismiss) private var dismis
    @State private var inputText: String = ""
    
    @StateObject var ketboard: KeyboardManager = .init()
    
    var body: some View {
//        ScrollView(content: {
        VStack {
                Text("Hello, World!")
                
                Button {
                    dismis()
                } label: {
                    Text("Close")
                }
            Spacer()
                Color.gray
                    .frame(maxHeight: .infinity)
                
                AutoHeightTextEditor(inputText: $inputText, placeholder: .constant("11111"))
                    .padding(.bottom, 20)
                
                Text("Hello, World!")
                
            }
        .frame(height: 500)
        .ignoresSafeArea()
//            .frame(maxHeight: .infinity)
//            .overlay(alignment: .bottom) {
//                AutoHeightTextEditor(inputText: $inputText, placeholder: .constant("11111"))
//                    .padding(.bottom, 20)
//            }
//        })
            .frame(maxWidth: .infinity)
            .background(.orange.opacity(0.7))
            .cornerRadius(15)
            .padding(.horizontal,20)
  

    }
}

#Preview {
    TestView()
}
#endif
