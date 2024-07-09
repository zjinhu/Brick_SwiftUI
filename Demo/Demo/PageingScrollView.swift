//
//  PageingScrollView.swift
//  BrickBrickDemo
//
//  Created by FunWidget on 2024/7/4.
//

import SwiftUI
import BrickKit
#if os(iOS)
struct PageingScrollView: View {
    var body: some View {
        PageScrollView(pageOutWidth: 50,
                       pagePadding: 10){
            
            ForEach(0 ..< 10, id: \.self) { index in
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(.orange)
                    .overlay {
                        Text("\(index)")
                    }
                    .onTapGesture {
                        print ("tap on index: \(index)")
                    }
                
            }
        }
        .frame(height: 228)
    }
}

#Preview {
    PageingScrollView()
}
#endif
