//
//  ListPickerSection.swift
//
//  Created by iOS on 2023/6/28.
//
//

import SwiftUI

/**
 This type can be used to defina a section in a list picker.
 */
public struct ListPickerSection<Item: Identifiable>: Identifiable {
    
    public init(title: String, items: [Item]) {
        self.id = UUID()
        self.title = title
        self.items = items
    }
    
    public let id: UUID
    public let title: String
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
