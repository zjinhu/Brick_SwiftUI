//
//  ListPickerItem.swift
//
//  Created by iOS on 2023/6/28.
//
//

import SwiftUI

/**
 This protocol can be implemented by `PickerItem` list items.
 
 The ``ListPickerItem/checkmark`` returns a checkmark if the
 item is selected, or an empty image if it's not. You should
 use the checkmark as a trailing icon to show if the item is
 selected or not.
 */
public protocol ListPickerItem: View {
    
    associatedtype Item: Equatable
    
    var item: Item { get }
    var isSelected: Bool { get }
}

public extension ListPickerItem {
    
    /// This checkmark image to use for the selection state.
    var checkmark: some View {
        Image(systemName: "checkmark")
            .visible(if: isSelected)
    }
}
