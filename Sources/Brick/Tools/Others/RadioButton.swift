//
//  SwiftUIView.swift
//  
//
//  Created by HU on 2024/4/29.
//

import SwiftUI

public struct RadioButton: View {
    @State var isSelected: Bool = true
    let label: String
    let action: (Bool) -> Void
    
    public init(isSelected: Bool = true,
                label: String,
                action: @escaping (Bool) -> Void) {
        self.isSelected = isSelected
        self.label = label
        self.action = action
    }
    
    public var body: some View {
        Button{
            self.isSelected.toggle()
            self.action(self.isSelected)
        }label: {
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: self.isSelected ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 14, height: 14)
                Text(label)
                    .font(.system(size: 15))
            }
        }
    }
}

#Preview {
    RadioButton(isSelected: false, label: "123") { bool in
        
    }
    .foregroundColor(.orange)
}
