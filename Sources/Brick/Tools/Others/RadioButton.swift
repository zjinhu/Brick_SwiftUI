//
//  SwiftUIView.swift
//  
//
//  Created by HU on 2024/4/29.
//

import SwiftUI

/// 单选按钮/Radio button
/// 带标签的单选按钮组件。/Radio button component with label.
public struct RadioButton: View {
    /// 是否选中/Whether selected
    @State var isSelected: Bool = true
    /// 标签文本/Label text
    let label: String
    /// 选中状态变化回调/Selection state change callback
    let action: (Bool) -> Void
    
    /// 初始化单选按钮/Initialize radio button
    /// - Parameters:
    ///   - isSelected: 是否选中，默认true/Whether selected, default true
    ///   - label: 标签文本/Label text
    ///   - action: 选中状态变化回调/Selection state change callback
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
