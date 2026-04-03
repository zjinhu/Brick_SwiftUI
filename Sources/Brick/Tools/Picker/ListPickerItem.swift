//
//  ListPickerItem.swift
//
//  Created by iOS on 2023/6/28.
//
//

import SwiftUI

/**
 可由 `PickerItem` 列表项实现的协议/This protocol can be implemented by `PickerItem` list items.
 
 ``ListPickerItem/checkmark`` 如果项目被选中则返回复选框，否则返回空图片/The ``ListPickerItem/checkmark`` returns a checkmark if the
 item is selected, or an empty image if it's not. You should
 use the checkmark as a trailing icon to show if the item is
 selected or not.
 */
public protocol ListPickerItem: View {
    
    associatedtype Item: Equatable
    
    /// 列表项/List item
    var item: Item { get }
    /// 是否选中/Whether selected
    var isSelected: Bool { get }
}

public extension ListPickerItem {
    
    /// 用于选择状态的复选框图片/The checkmark image to use for the selection state.
    var checkmark: some View {
        Image(systemName: "checkmark")
            .visible(if: isSelected)
    }
}
