//
//  SwiftUIView.swift
//  
//
//  Created by 狄烨 on 2023/10/8.
//

import SwiftUI

public struct EasyLoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    private var content: () -> Content
    
    public init(isShowing: Binding<Bool>, @ViewBuilder _ content: @escaping () -> Content) {
        self._isShowing = isShowing
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            
            self.content()
                .disabled(isShowing)

            BlurView()
                .opacity(isShowing ? 1 : 0)
                .ignoresSafeArea()
            
            ZStack{
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                
                ProgressView()
                    .frame(width: 50, height: 50)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
#if os(iOS)
                    .scaleEffect(2)
#endif
            }
            .frame(width: 80, height: 80)
            .cornerRadius(10)
            .opacity(isShowing ? 1 : 0)
            .shadow(color: .gray, radius: 5)

        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    EasyLoadingView(isShowing: .constant(true)) {
        NavigationView {
            List(["1", "2", "3", "4", "5"], id: \.self) { row in
                Text(row)
            }.navigationBarTitle(Text("Loader Test"), displayMode: .large)
        }
    }
}
