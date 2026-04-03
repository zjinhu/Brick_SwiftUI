//
//  ListMultiPicker.swift
//
//  Created by iOS on 2023/6/28.
//
//

import SwiftUI

/**
 此泛型选择器在 SwiftUI `List` 中列出 `Identifiable` 项目，并将 `selection` 绑定到外部值/This generic picker lists `Identifiable` items in a SwiftUI
 `List` and binds its `selection` to an external value.
 
 可以使用此视图代替原生 SwiftUI `Picker` 以更好地控制列表项视图/You can use this view instead of the native SwiftUI `Picker`
 to get more control over the list item views. The view uses
 the provided `listItem` to build an item view for each item.
 */
public struct ListMultiPicker<Item: Identifiable, ItemView: View>: View {
    
    /// 创建列表选择器/Create a list picker.
    ///
    /// - Parameters:
    ///   - items: 选择器中列出的项目/The items to list in the picker.
    ///   - selection: 当前选中项/The current selection.
    ///   - listItem: 列表视图构建器/A list view builder.
    public init(
        items: [Item],
        selection: Binding<[Item]>,
        listItem: @escaping ItemViewBuilder
    ) {
        self.init(
            sections: [ListPickerSection(title: "", items: items)],
            selection: selection,
            listItem: listItem
        )
    }
    
    /// 创建带多个分区的列表选择器/Create a list picker with multiple sections.
    ///
    /// - Parameters:
    ///   - sections: 选择器中列出的分区/The sections to list in the picker.
    ///   - selection: 当前选中项/The current selection.
    ///   - listItem: 列表视图构建器/A list view builder.
    public init(
        sections: [ListPickerSection<Item>],
        selection: Binding<[Item]>,
        listItem: @escaping ItemViewBuilder
    ) {
        self.sections = sections
        self.selection = selection
        self.listItem = listItem
    }
    
    private let sections: [ListPickerSection<Item>]
    private let selection: Binding<[Item]>
    private let listItem: ItemViewBuilder
    
    public typealias ItemViewBuilder = (_ item: Item, _ isSelected: Bool) -> ItemView
    
    @Environment(\.dismiss)
    public var dismiss
    
    public var body: some View {
        List {
            ForEach(sections) { section in
                Section(header: section.header) {
                    ForEachMultiPicker(
                        items: section.items,
                        selection: selection,
                        listItem: listItem
                    )
                }
            }
        }
    }
}

private extension View {
    
    @ViewBuilder
    func withTitle(_ title: String) -> some View {
        #if os(iOS) || os(tvOS) || os(watchOS)
        self.navigationBarTitle(title)
        #else
        self
        #endif
    }
}

#Preview {
    
    struct Preview: View {
        
        @State private var selection = [PreviewItem.all[0]]
        
        func section(_ title: String) -> ListPickerSection<PreviewItem> {
            ListPickerSection(
                title: title,
                items: PreviewItem.all
            )
        }
        
        var body: some View {
            NavigationView {
                ListMultiPicker(
                    sections: [
                        section("First section"),
                        section("Another section")
                    ],
                    selection: $selection
                ) { item, isSelected in
                    ListSelectItem(isSelected: isSelected) {
                        Text(item.name)
                    }
                }.withTitle("Pick multiple items")
            }
        }
    }
    
    struct PreviewItem: Identifiable, Equatable {
        
        let name: String
        
        var id: String { name }
        
        static let all = [
            PreviewItem(name: "Item #1"),
            PreviewItem(name: "Item #2"),
            PreviewItem(name: "Item #3"),
            PreviewItem(name: "Item #4"),
            PreviewItem(name: "Item #5"),
            PreviewItem(name: "Item #6"),
            PreviewItem(name: "Item #7"),
            PreviewItem(name: "Item #8"),
            PreviewItem(name: "Item #9"),
            PreviewItem(name: "Item #10"),
            PreviewItem(name: "Item #11"),
            PreviewItem(name: "Item #12"),
            PreviewItem(name: "Item #13"),
            PreviewItem(name: "Item #14"),
            PreviewItem(name: "Item #15")
        ]
    }
    
    return Preview()
}
