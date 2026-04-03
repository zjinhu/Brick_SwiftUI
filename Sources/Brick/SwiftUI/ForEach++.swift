//
//  ForEach++.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  ForEach 扩展 - 提供索引访问和元素插入功能 / ForEach extension - provides index access and element interleaving
//

import SwiftUI

// MARK: - ForEach init with index / ForEach 带索引初始化

/// ForEach 带索引初始化扩展 / ForEach init with index extension
extension ForEach {
    /// 从集合创建 ForEach，同时提供索引 / Creates ForEach from collection with index
    /// - Parameters:
    ///   - data: 数据集合 / Data collection
    ///   - content: 内容构建闭包 / Content building closure
    @_disfavoredOverload
    @inlinable
    public init<_Data: RandomAccessCollection>(
        _ data: _Data,
        @ViewBuilder content: @escaping (_Data.Index, _Data.Element) -> Content
    ) where Data == Array<(_Data.Index, _Data.Element)>, ID == _Data.Index, Content: View {
        let elements = Array(zip(data.indices, data))
        self.init(elements, id: \.0) { index, element in
            content(index, element)
        }
    }

    /// 从集合创建 ForEach，带索引和 ID / Creates ForEach with index and ID from collection
    @inlinable
    public init<_Data: RandomAccessCollection>(
        _ data: _Data,
        id: KeyPath<_Data.Element, ID>,
        @ViewBuilder content: @escaping (_Data.Index, _Data.Element) -> Content
    ) where Data == Array<(_Data.Index, _Data.Element)>, Content: View {
        let elements = Array(zip(data.indices, data))
        let elementPath: KeyPath<(_Data.Index, _Data.Element), _Data.Element> = \.1
        self.init(elements, id: elementPath.appending(path: id)) { index, element in
            content(index, element)
        }
    }

    /// 从集合创建 ForEach，带索引 (Identifiable) / Creates ForEach with index from Identifiable collection
    @inlinable
    public init<_Data: RandomAccessCollection>(
        _ data: _Data,
        @ViewBuilder content: @escaping (_Data.Index, _Data.Element) -> Content
    ) where Data == Array<(_Data.Index, _Data.Element)>, _Data.Element: Identifiable, ID == _Data.Element.ID, Content: View {
        let elements = Array(zip(data.indices, data))
        self.init(elements, id: \.1.id) { index, element in
            content(index, element)
        }
    }
}

// MARK: - ForEach properties / ForEach 属性

/// ForEach 属性扩展 / ForEach properties extension
extension ForEach {
    /// 是否为空 / Whether is empty
    public var isEmpty: Bool {
        data.isEmpty
    }
    
    /// 元素数量 / Element count
    public var count: Int {
        data.count
    }
}

// MARK: - ForEach enumerating / ForEach 枚举初始化

/// ForEach 枚举初始化扩展 / ForEach enumerating init extension
extension ForEach where Content: View {
  
    /// 从集合枚举创建 ForEach / Creates ForEach from collection enumeration
    /// - Parameters:
    ///   - data: 数据集合 / Data collection
    ///   - id: 标识路径 / ID key path
    ///   - rowContent: 行内容构建闭包 / Row content building closure
    public init<Elements: RandomAccessCollection>(
        enumerating data: Elements,
        id: KeyPath<Elements.Element, ID>,
        @ViewBuilder rowContent: @escaping (Int, Elements.Element) -> Content
    ) where Data == [_KeyPathIdentifiableElementOffsetPair<Elements.Element, Int, ID>] {
        self.init(data.enumerated().map({ _KeyPathIdentifiableElementOffsetPair(element: $0.element, offset: $0.offset, id: id) })) {
            rowContent($0.offset, $0.element)
        }
    }
    
    /// 从集合枚举创建 ForEach (无 ID) / Creates ForEach from enumeration without ID
    @_disfavoredOverload
    public init<Elements: RandomAccessCollection>(
        enumerating data: Elements,
        @ViewBuilder rowContent: @escaping (Int, Elements.Element) -> Content
    ) where Data == [_OffsetIdentifiedElementOffsetPair<Elements.Element, Int>], ID == Int {
        self.init(data.enumerated().map({ _OffsetIdentifiedElementOffsetPair(element: $0.element, offset: $0.offset) }), id: \.offset) {
            rowContent($0.offset, $0.element)
        }
    }
    
    /// 从集合枚举创建 ForEach (无索引) / Creates ForEach from enumeration without index
    @_disfavoredOverload
    public init<Elements: RandomAccessCollection>(
        enumerating data: Elements,
        @ViewBuilder rowContent: @escaping (Elements.Element) -> Content
    ) where Data == [_OffsetIdentifiedElementOffsetPair<Elements.Element, Int>], ID == Int {
        self.init(data.enumerated().map({ _OffsetIdentifiedElementOffsetPair(element: $0.element, offset: $0.offset) }), id: \.offset) {
            rowContent($0.element)
        }
    }

    /// 从 Identifiable 集合枚举创建 ForEach / Creates ForEach from Identifiable collection enumeration
    public init<Elements: RandomAccessCollection>(
        enumerating data: Elements,
        @ViewBuilder rowContent: @escaping (Int, Elements.Element) -> Content
    ) where Elements.Element: Identifiable, Data == [_IdentifiableElementOffsetPair<Elements.Element, Int>], ID == Elements.Element.ID {
        self.init(data.enumerated().map({ _IdentifiableElementOffsetPair(element: $0.element, offset: $0.offset) })) {
            rowContent($0.offset, $0.element)
        }
    }
}

// MARK: - ForEach interleaving / ForEach 插入功能

/// ForEach 插入分隔符扩展 / ForEach interleave separator extension
extension ForEach where Data.Element: Identifiable, Content: View, ID == Data.Element.ID {
    /// 在元素之间插入分隔符 / Insert separator between elements
    /// - Parameter separator: 分隔视图 / Separator view
    public func interleave<Separator: View>(with separator: Separator) -> some View {
        let data = self.data.enumerated().map({ _IdentifiableElementOffsetPair(element: $0.element, offset: $0.offset) })
        
        return ForEach<[_IdentifiableElementOffsetPair<Data.Element, Int>], Data.Element.ID,  Group<TupleView<(Content, Separator?)>>>(data) { pair in
            Group {
                self.content(pair.element)
                
                if pair.offset != (data.count - 1) {
                    separator
                }
            }
        }
    }
}

/// ForEach 插入分割线扩展 / ForEach interleave divider extension
extension ForEach where Data.Element: Identifiable, Content: View, ID == Data.Element.ID {
    /// 在元素之间插入 Divider / Insert Divider between elements
    public func interdivided() -> some View {
        let data = self.data.enumerated().map({ _IdentifiableElementOffsetPair(element: $0.element, offset: $0.offset) })
        
        return ForEach<[_IdentifiableElementOffsetPair<Data.Element, Int>], Data.Element.ID,  Group<TupleView<(Content, Divider?)>>>(data) { pair in
            Group {
                self.content(pair.element)
                
                if pair.offset != (data.count - 1) {
                    Divider()
                }
            }
        }
    }
}

/// ForEach 插入间距扩展 / ForEach interleave spacer extension
@MainActor
extension ForEach where Data.Element: Identifiable, Content: View, ID == Data.Element.ID {
    /// 在元素之间插入 Spacer / Insert Spacer between elements
    public func interspaced() -> some View {
        let data = self.data.enumerated().map({ _IdentifiableElementOffsetPair(element: $0.element, offset: $0.offset) })
        
        return ForEach<[_IdentifiableElementOffsetPair<Data.Element, Int>], Data.Element.ID,  Group<TupleView<(Content, Spacer?)>>>(data) { pair in
            Group {
                self.content(pair.element)
                
                if pair.offset != (data.count - 1) {
                    Spacer()
                }
            }
        }
    }
}

// MARK: - ForEach CaseIterable / ForEach 枚举类型

/// ForEach 枚举类型初始化 / ForEach CaseIterable init
extension ForEach where ID: CaseIterable & Hashable, ID.AllCases: RandomAccessCollection, Content: View, Data == ID.AllCases {
    /// 从枚举所有值创建 ForEach / Creates instance that uniquely identifies and creates views over `ID.allCases`
    /// - Parameters:
    ///   - type: 枚举类型 / Enum type
    ///   - content: 内容构建闭包 / Content building closure
    public init(
        _ type: ID.Type,
        @ViewBuilder content: @escaping (ID) -> Content
    ) {
        self.init(ID.allCases, id: \.self, content: content)
    }
}

// MARK: - Binding Extension / Binding 扩展

/// Binding 扩展 / Binding extension
extension Binding {
    fileprivate struct _BindingIdentifiableKeyPathAdaptor {
        let base: Binding<Value>
        
        subscript<ID>(keyPath keyPath: KeyPath<Value, ID>) -> ID {
            base.wrappedValue[keyPath: keyPath]
        }
    }
    
    fileprivate var _bindingIdentifiableKeyPathAdaptor: _BindingIdentifiableKeyPathAdaptor {
        .init(base: self)
    }
}

// MARK: - Helper Structures / 辅助结构

/// 可识别元素与偏移量配对 / Identifiable element and offset pair
public struct _IdentifiableElementOffsetPair<Element: Identifiable, Offset>: Identifiable {
    let element: Element
    let offset: Offset
    
    public var id: Element.ID {
        element.id
    }
    
    init(element: Element, offset: Offset) {
        self.element = element
        self.offset = offset
    }
}

/// 带偏移量的元素对 / Element pair with offset
public struct _OffsetIdentifiedElementOffsetPair<Element, Offset> {
    let element: Element
    let offset: Offset
    
    init(element: Element, offset: Offset) {
        self.element = element
        self.offset = offset
    }
}

/// KeyPath 标识的元素与偏移量对 / KeyPath identifiable element and offset pair
public struct _KeyPathIdentifiableElementOffsetPair<Element, Offset, ID: Hashable>: Identifiable {
    let element: Element
    let offset: Offset
    let keyPathToID: KeyPath<Element, ID>
    
    public var id: ID {
        element[keyPath: keyPathToID]
    }
    
    init(element: Element, offset: Offset, id: KeyPath<Element, ID>) {
        self.element = element
        self.offset = offset
        self.keyPathToID = id
    }
}
