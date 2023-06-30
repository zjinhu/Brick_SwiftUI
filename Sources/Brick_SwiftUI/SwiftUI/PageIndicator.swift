//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/30.
//

import SwiftUI

struct PageIndicatorView: View {
    // Constants
    private let spacing: CGFloat
    private let height: CGFloat
    private let currentWidth: CGFloat
    private let color: Color
    // Settings
    private let numPages: Int
    @Binding private var selectedIndex: Int
    
    init(numPages: Int,
         currentPage: Binding<Int>,
         height: CGFloat = 8,
         currentWidth: CGFloat = 20,
         spacing: CGFloat = 15,
         color: Color = .black
    ) {
        self.numPages = numPages
        self._selectedIndex = currentPage
        
        self.height = height
        self.currentWidth = currentWidth
        self.spacing = spacing
        self.color = color
    }
    
    var body: some View {
        VStack {
            HStack(spacing: spacing) {
                ForEach(0..<numPages, id: \.self) { index in
                    Capsule()
                        .frame(width: selectedIndex == index ? currentWidth : height, height: height)
                        .animation(.spring(), value: UUID())
                        .foregroundColor(
                            selectedIndex == index
                            ? Color.black
                            : Color.black.opacity(0.6)
                        )

                }
            }
        }
    }
}

struct PageIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        PageIndicatorView(numPages: 5, currentPage: .constant(2))
            .previewDisplayName("Regular")
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}
