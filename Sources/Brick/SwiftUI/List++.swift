//
//  List++.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  List 扩展 - 提供带选中状态的 List 初始化方法 / List extension - provides List initialization with selection state
//

import SwiftUI

// MARK: - List Extension with Selection / List 带选中的扩展

/// List 扩展 / List extension
extension List {
    /// 初始化带多选的 List / Initialize List with multi-selection (ID based)
    /// - Parameters:
    ///   - data: 数据集合 / Data collection
    ///   - selection: 选中项绑定 / Selection binding
    ///   - rowContent: 行内容闭包 / Row content closure
    #if swift(>=5.5.1) || (swift(>=5.5) && !targetEnvironment(macCatalyst) && !os(macOS))
    @available(watchOS, unavailable)
    public init<Data: RandomAccessCollection, RowContent: View>(
        _ data: Data,
        selection: Binding<Set<SelectionValue>>,
        @ViewBuilder rowContent: @escaping (Data.Element, _ isSelected: Bool) -> RowContent
    ) where Data.Element: Identifiable, Content == ForEach<Data, Data.Element.ID, RowContent>, SelectionValue == Data.Element.ID {
        self.init(data, selection: selection, rowContent: { element in
            rowContent(element, selection.wrappedValue.contains(element.id))
        })
    }
    
    /// 初始化带多选的 List / Initialize List with multi-selection (Element based)
    @available(watchOS, unavailable)
    public init<Data: RandomAccessCollection, RowContent: View>(
        _ data: Data,
        selection: Binding<Set<SelectionValue>>,
        @ViewBuilder rowContent: @escaping (Data.Element, _ isSelected: Bool) -> RowContent
    ) where Data.Element: Identifiable, Content == ForEach<Data, Data.Element.ID, RowContent>, SelectionValue == Data.Element {
        self.init(data, selection: selection, rowContent: { element in
            rowContent(element, selection.wrappedValue.contains(element))
        })
    }
    #else
    @available(watchOS, unavailable)
    public init<Data: RandomAccessCollection, RowContent: View>(
        _ data: Data,
        selection: Binding<Set<SelectionValue>>,
        @ViewBuilder rowContent: @escaping (Data.Element, _ isSelected: Bool) -> RowContent
    ) where Data.Element: Identifiable, Content == ForEach<Data, Data.Element.ID, HStack<RowContent>>, SelectionValue == Data.Element.ID {
        self.init(data, selection: selection, rowContent: { element in
            rowContent(element, selection.wrappedValue.contains(element.id))
        })
    }
    
    @available(watchOS, unavailable)
    public init<Data: RandomAccessCollection, RowContent: View>(
        _ data: Data,
        selection: Binding<Set<SelectionValue>>,
        @ViewBuilder rowContent: @escaping (Data.Element, _ isSelected: Bool) -> RowContent
    ) where Data.Element: Identifiable, Content == ForEach<Data, Data.Element.ID, HStack<RowContent>>, SelectionValue == Data.Element {
        self.init(data, selection: selection, rowContent: { element in
            rowContent(element, selection.wrappedValue.contains(element))
        })
    }
    #endif
}
