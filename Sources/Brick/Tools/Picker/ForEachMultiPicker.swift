//
//  ForEachMultiPicker.swift
//
//  Created by iOS on 2023/6/28.
//
//

import SwiftUI

/**
 此泛型选择器在 SwiftUI `ForEach` 中列出 `Identifiable` 项目，并将 `selection` 绑定到外部值/This generic picker lists `Identifiable` items in a SwiftUI
 `ForEach` and binds its `selection` to an external value.
 
 可以使用此视图代替原生 SwiftUI `Picker` 以更好地控制列表项视图/You can use this view instead of the native SwiftUI `Picker`
 to get more control over the list item views. The view uses
 the provided `listItem` to build an item view for each item.
 */
public struct ForEachMultiPicker<Item: Identifiable, ItemView: View>: View {
    
    /// 创建 ForEach 多选选择器/Create a for-each multi-picker.
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
        self.items = items
        self.selection = selection
        self.listItem = listItem
    }
    
    private let items: [Item]
    private let selection: Binding<[Item]>
    private let listItem: ItemViewBuilder
    
    public typealias ItemViewBuilder = (_ item: Item, _ isSelected: Bool) -> ItemView
    
    @Environment(\.dismiss)
    public var dismiss
    
    public var body: some View {
        ForEach(items) { item in
            Button(action: { toggleSelection(for: item) }, label: {
                listItem(item, isSelected(item))
            })
        }
    }
}

private extension ForEachMultiPicker {
    
    var selectedIds: [Item.ID] {
        selection.wrappedValue.map { $0.id }
    }
    
    func isSelected(_ item: Item) -> Bool {
        selectedIds.contains(item.id)
    }
    
    func toggleSelection(for item: Item) {
        if isSelected(item) {
            selection.wrappedValue = selection.wrappedValue.filter { $0.id != item.id }
        } else {
            selection.wrappedValue.append(item)
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
        
        @State
        private var selection = [PreviewItem.all[0]]
        
        var body: some View {
            NavigationView {
                List {
                    ForEachMultiPicker(
                        items: PreviewItem.all,
                        selection: $selection) { item, isSelected in
                            ListSelectItem(isSelected: isSelected) {
                                Text(item.name)
                            }
                        }
                }
                .withTitle("Pick multiple items")
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
