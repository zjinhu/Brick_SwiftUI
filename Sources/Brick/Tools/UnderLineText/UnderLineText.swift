//
//  UnderLineView.swift
//  AIChat
//
//  Created by iOS on 2023/7/7.
//  下划线文本输入组件/Underline text input component
//  带下划线样式的文本输入框/Text input with underline style

import SwiftUI

/// 下划线文本组件/Underline text component
public struct UnderLineText: View {
    /// 标题/Title
    @Environment(\.underLineTitle) private var underLineTitle
    /// 标题颜色/Title color
    @Environment(\.underLineTitleColor) private var underLineTitleColor
    /// 标题字体/Title font
    @Environment(\.underLineTitleFont) private var underLineTitleFont
    
    /// 文本/Text
    @Environment(\.underLineText) private var underLineText
    /// 文本字体/Text font
    @Environment(\.underLineTextFont) private var underLineTextFont
    /// 文本颜色/Text color
    @Environment(\.underLineTextColor) private var underLineTextColor
    
    /// 文本高度/Text height
    @Environment(\.underLineTextHeight) private var underLineTextHeight
    /// 文本截断模式/Text truncation mode
    @Environment(\.underLineTextTruncationMode) private var underLineTextTruncationMode
    
    /// 下划线颜色/Underline color
    @Environment(\.underLineColor) private var underLineColor
    /// 下划线高度/Underline height
    @Environment(\.underLineHeight) private var underLineHeight
    
    /// 左侧视图/Leading view
    @Environment(\.underLineLeadingView) private var underLineLeadingView
    /// 右侧视图/Trailing view
    @Environment(\.underLineTrailingView) private var underLineTrailingView
    
    /// 初始化/Initialize
    public init(){}
    
    public var body: some View {
        VStack(spacing: 8){
            
            if let underLineTitle{
                Text(underLineTitle)
                    .font(underLineTitleFont)
                    .foregroundColor(underLineTitleColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(alignment: .leading, spacing: 0){
                HStack(spacing: 0){
                    if let underLineLeadingView {
                        underLineLeadingView()
                            .padding(.trailing, 10)
                    }
                    
                    Text(underLineText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 1)
                        .frame(height: underLineTextHeight)
                        .foregroundColor(underLineTextColor)
                        .truncationMode(underLineTextTruncationMode)
                        .background(Color.clear)
                    
                    Spacer()
                    
                    if let underLineTrailingView {
                        underLineTrailingView()
                            .padding(.trailing, 12)
                    }
  
                }
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: underLineHeight)
                    .foregroundColor(underLineColor)
            }
        }
    }

}
#if !os(tvOS)

struct UnderLineTextView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
    
    struct Preview: View{
        @State var birthday: Date = Date()
        
        var body: some View {
            UnderLineText()
                .underLineText("Text")
                .underLineTitle("Title")
                .underLineColor(.red)
                .underLineLeadingView{
                    Image(symbol: .calendar)
                }
                .underLineTrailingView {

                    DatePicker("", selection: $birthday, displayedComponents: .date)
                }
                .padding()
        }
    }
}
#endif
