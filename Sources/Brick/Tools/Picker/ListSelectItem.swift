//
//  ListSelectItem.swift
//
//  Created by iOS on 2023/6/28.
//
//

import SwiftUI

/**
 此视图将提供的内容包装在 `HStack` 中，并在选中时添加尾随图像/This view wraps the provided content within an `HStack` and
 adds a trailing image if the view is selected.

 虽然 `selectedImage` 默认为复选框，但选择指示器视图可以是任何自定义视图/Although the `selectedImage` is a checkmark by default, the
 selection indicator view can be any custom view.
 */
public struct ListSelectItem<Content: View, SelectIndicator: View>: View {

    /**
     创建列表选择项/Create a list select item.

     - Parameters:
       - isSelected: 项目是否被选中/Whether or not the item is selected.
       - selectIndicator: 为选中项显示的视图/The view to show for selected views.
       - content: 列表项内容视图/The list item content view.
     */
    public init(
        isSelected: Bool,
        selectIndicator: SelectIndicator,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isSelected = isSelected
        self.selectedIndicator = selectIndicator
        self.content = content
    }

    /**
     创建列表选择项（使用默认图片）/Create a list select item.

     - Parameters:
       - isSelected: 项目是否被选中/Whether or not the item is selected.
       - selectedImage: 为选中项显示的图片，默认为 `.checkmark`/The image to show for selected views, by default `.checkmark`.
       - content: 列表项内容视图/The list item content view.
     */
    public init(
        isSelected: Bool,
        selectedImage: Image = Image(systemName: "checkmark"),
        @ViewBuilder content: @escaping () -> Content
    ) where SelectIndicator == Image {
        self.isSelected = isSelected
        self.selectedIndicator = selectedImage
        self.content = content
    }
    
    private let isSelected: Bool
    private let selectedIndicator: SelectIndicator
    private let content: () -> Content
    
    public var body: some View {
        HStack {
            content()
            Spacer()
            if isSelected {
                selectedIndicator
            }
        }
    }
}

#Preview {
    
    struct Preview: View {
        
        @State
        private var selection = 0
        
        var body: some View {
            List {
                ForEach(0...10, id: \.self) { index in
                    Group {
                        ListSelectItem(isSelected: index == selection) {
                            Image.symbol("\(index).circle")
                                .label(
                                    "Preview.Item.\(index)",
                                    bundle: .module
                                )
                        }
                        ListSelectItem(
                            isSelected: index == selection,
                            selectIndicator: Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        ) {
                            Image.symbol("\(index).circle")
                                .label("Preview.Item.\(index)", bundle: .module)
                        }
                    }
                    #if os(iOS) || os(macOS) || os(visionOS)
                    .onTapGesture {
                        selection = index
                    }
                    #endif
                }
            }
        }
    }
    
    return Preview()
}
