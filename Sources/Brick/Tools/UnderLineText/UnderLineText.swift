//
//  UnderLineView.swift
//  AIChat
//
//  Created by iOS on 2023/7/7.
//

import SwiftUI

public struct UnderLineText: View {
 
    @Environment(\.underLineTitle) private var underLineTitle
    @Environment(\.underLineTitleColor) private var underLineTitleColor
    @Environment(\.underLineTitleFont) private var underLineTitleFont
    
    @Environment(\.underLineText) private var underLineText
    @Environment(\.underLineTextFont) private var underLineTextFont
    @Environment(\.underLineTextColor) private var underLineTextColor
    
    @Environment(\.underLineTextHeight) private var underLineTextHeight
    @Environment(\.underLineTextTruncationMode) private var underLineTextTruncationMode
    
    @Environment(\.underLineColor) private var underLineColor
    @Environment(\.underLineHeight) private var underLineHeight
    
    @Environment(\.underLineLeadingView) private var underLineLeadingView
    @Environment(\.underLineTrailingView) private var underLineTrailingView
    
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
