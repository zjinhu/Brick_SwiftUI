//
//  SwiftUIView.swift
//  Example
//
//  Created by iOS on 2023/6/9.
//

import SwiftUI
import BrickKit

enum Segment: Identifiable, CaseIterable {
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

enum SegmentedTab: String, CaseIterable {
    case home = "house.fill"
    case favorites = "suit.heart.fill"
    case notifications = "bell.fill"
    case profile = "person.fill"
}

struct SegmentStylesView: View {
    
    @Environment(\.dismiss) private var dismiss
#if os(iOS)
    @Environment(\.requestReview) private var requestReview
#endif
    
    @State private var selected = Segment.noon
    @State private var selection = Segment.noon
    
    let titles: [String] = ["1", "2", "3", "4"]
    @State var selectedIndex: Int?
    
    @State var activeTab: SegmentedTab = .home
    @State var activeTab2: SegmentedTab = .home
    
    var body: some View {
        
        VScrollStack(spacing: 20){
 
            SegmentView(segments: Segment.allCases,
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

            
            Picker(selection: $selection) {
                ForEach(Segment.allCases) { segment in
                    Text(segment.title)
                        .tag(segment)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selection) { new in
                withAnimation(.default) {
                    selected = selection
                }
            }
            
            SegmentedPicker(
                 titles,
                 selectedIndex: Binding(
                     get: { selectedIndex },
                     set: { selectedIndex = $0 }),
                 selectionAlignment: .bottom,
                 content: { item, isSelected in
                     Text(item)
                         .foregroundColor(isSelected ? Color.black : Color.gray )
                         .padding(.horizontal, 16)
                         .padding(.vertical, 8)
                 },
                 selection: {
                     VStack(spacing: 0) {
                         Spacer()
                         Color.black.frame(height: 1)
                     }
                 })
                 .onAppear {
                     selectedIndex = 0
                 }
                 .animation(.easeInOut(duration: 0.3))
            
            SegmentControl(
                tabs: SegmentedTab.allCases,
                activeTab: $activeTab,
                height: 30,
                displayAsText: false,
                font: .body,
                activeTint: .primary,
                inActiveTint: .gray.opacity(0.5)
            ) { size in
                RoundedRectangle(cornerRadius: 2)
                    .fill(.blue)
                    .frame(height: 4)
                    .padding(.horizontal, 10)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .padding(.top, 10)
            .background() {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.orange)
                    .ignoresSafeArea()
            }
            .padding(.horizontal, 15)
            
            SegmentControl(
                tabs: SegmentedTab.allCases,
                activeTab: $activeTab2,
                height: 30,
                displayAsText: false,
                font: .body,
                activeTint: .primary,
                inActiveTint: .gray.opacity(0.5)
            ) { size in
                RoundedRectangle(cornerRadius: 30)
                    .fill(.blue)
                    .frame(height: size.height-4)
                    .padding(.horizontal, 2)
                    .frame(maxHeight: .infinity, alignment: .center)
            }
            .padding(.top, 0)
            .background() {
                RoundedRectangle(cornerRadius: 30)
                    .fill(.orange)
                    .ignoresSafeArea()
            }
            .padding(.horizontal, 15)
            
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

