//
//  ListPickerSection.swift
//
//  Created by iOS on 2023/6/28.
//
//

import SwiftUI

/**
 用于定义列表选择器中的分区/This type can be used to define a section in a list picker.
 */
public struct ListPickerSection<Item: Identifiable>: Identifiable {
    
    /// 初始化选择器分区/Initialize picker section
    /// - Parameters:
    ///   - title: 分区标题/Section title
    ///   - items: 分区中的项目/Items in section
    public init(title: String, items: [Item]) {
        self.id = UUID()
        self.title = title
        self.items = items
    }
    
    /// 唯一标识符/Unique identifier
    public let id: UUID
    /// 分区标题/Section title
    public let title: String
    /// 分区中的项目/Items in section
    public let items: [Item]
    
    @ViewBuilder
    var header: some View {
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            EmptyView()
        } else {
            Text(title)
        }
    }
}
