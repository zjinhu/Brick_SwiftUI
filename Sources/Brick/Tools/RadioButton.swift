//
//  SwiftUIView.swift
//  
//
//  Created by HU on 2024/4/29.
//

import SwiftUI

struct RadioButton: View {
    @State var isSelected: Bool = true
    let label: String
    let action: (Bool) -> Void

    var body: some View {
        Button{ 
            self.isSelected.toggle()
            self.action(self.isSelected)
        }label: {
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: self.isSelected ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 14, height: 14)
                Text(label)
                    .font(.f15)
            }
        }
        .foregroundColor(self.isSelected ? .textColor : .buttonunSelectedColor)
    }
}

#Preview {
    RadioButton(label: "123") { bool in
        
    }
}
