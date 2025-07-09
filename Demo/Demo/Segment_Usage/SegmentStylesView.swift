//
//  SwiftUIView.swift
//  Example
//
//  Created by iOS on 2023/6/9.
//

import SwiftUI
import BrickKit
#if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)

enum Segment: Identifiable, CaseIterable, Equatable {
    case morning, noon, evening
    
    var id: String {
        title
    }
    
    var title: String {
        switch self {
        case .morning:
            return "Morning"
        case .noon:
            return "Noon"
        case .evening:
            return "Evening"
        }
    }
}

struct SegmentStylesView: View {
    
    @Environment(\.dismiss) private var dismiss
#if os(iOS)
    @Environment(\.requestReview) private var requestReview
#endif
    
    @State private var selected = Segment.noon
    @State private var selection = Segment.noon

    var body: some View {
        
        VScrollStack(spacing: 20){
 
            CustomSegmentPicker(segments: Segment.allCases,
                        selected: $selected,
                        normalColor: .primary,
                        selectedColor: .primary,
                        selectedBackColor: .white,
                        bgColor: .gray.opacity(0.2)) { seg in
                
                Text(seg.title)

            } background: {
//                RoundedRectangle(cornerRadius: 10)
                Capsule()
            }
            .height(40)
            .padding()

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
#if os(iOS)
            Button {
                requestReview()
            } label: {
                Text("Request Review")
            }
#endif

        }
#if os(iOS)
        .ss.tabBar(.hidden)
#endif
 
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentStylesView()
    }
}

#endif
