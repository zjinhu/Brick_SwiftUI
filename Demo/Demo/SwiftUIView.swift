//
//  SwiftUIView.swift
//  Example
//
//  Created by iOS on 2023/6/9.
//

import SwiftUI
import Brick_SwiftUI

struct SwiftUIView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.requestReview) private var requestReview

    var body: some View {
        
        VScrollStack(spacing: 20){
 
            Button {
                dismiss()
            } label: {
                Text("Environment Dismiss")
                    .frame(width: 100, height: 50)
                    .background {
                        Color.orange
                    }
            }
            
            Spacer.height(20)
            
            HStack{
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            .ss.background {
                Color.orange
            }
            
            Button {
                requestReview()
            } label: {
                Text("Request Review")
            }
            

        }
#if !os(xrOS)
        .ss.tabBar(.hidden)
#endif
 
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

