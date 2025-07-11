//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI

extension ForEach {
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


extension ForEach {
    public var isEmpty: Bool {
        data.isEmpty
    }
    
    public var count: Int {
        data.count
    }
}

extension ForEach where Content: View {
 
    public init<Elements: RandomAccessCollection>(
        enumerating data: Elements,
        id: KeyPath<Elements.Element, ID>,
        @ViewBuilder rowContent: @escaping (Int, Elements.Element) -> Content
    ) where Data == [_KeyPathIdentifiableElementOffsetPair<Elements.Element, Int, ID>] {
        self.init(data.enumerated().map({ _KeyPathIdentifiableElementOffsetPair(element: $0.element, offset: $0.offset, id: id) })) {
            rowContent($0.offset, $0.element)
        }
    }
    
    @_disfavoredOverload
    public init<Elements: RandomAccessCollection>(
        enumerating data: Elements,
        @ViewBuilder rowContent: @escaping (Int, Elements.Element) -> Content
    ) where Data == [_OffsetIdentifiedElementOffsetPair<Elements.Element, Int>], ID == Int {
        self.init(data.enumerated().map({ _OffsetIdentifiedElementOffsetPair(element: $0.element, offset: $0.offset) }), id: \.offset) {
            rowContent($0.offset, $0.element)
        }
    }
    
    @_disfavoredOverload
    public init<Elements: RandomAccessCollection>(
        enumerating data: Elements,
        @ViewBuilder rowContent: @escaping (Elements.Element) -> Content
    ) where Data == [_OffsetIdentifiedElementOffsetPair<Elements.Element, Int>], ID == Int {
        self.init(data.enumerated().map({ _OffsetIdentifiedElementOffsetPair(element: $0.element, offset: $0.offset) }), id: \.offset) {
            rowContent($0.element)
        }
    }

    public init<Elements: RandomAccessCollection>(
        enumerating data: Elements,
        @ViewBuilder rowContent: @escaping (Int, Elements.Element) -> Content
    ) where Elements.Element: Identifiable, Data == [_IdentifiableElementOffsetPair<Elements.Element, Int>], ID == Elements.Element.ID {
        self.init(data.enumerated().map({ _IdentifiableElementOffsetPair(element: $0.element, offset: $0.offset) })) {
            rowContent($0.offset, $0.element)
        }
    }
}

extension ForEach where Data.Element: Identifiable, Content: View, ID == Data.Element.ID {
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

extension ForEach where Data.Element: Identifiable, Content: View, ID == Data.Element.ID {
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

@MainActor
extension ForEach where Data.Element: Identifiable, Content: View, ID == Data.Element.ID {
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

extension ForEach where ID: CaseIterable & Hashable, ID.AllCases: RandomAccessCollection, Content: View, Data == ID.AllCases {
    /// Creates an instance that uniquely identifies and creates views over `ID.allCases`.
    public init(
        _ type: ID.Type,
        @ViewBuilder content: @escaping (ID) -> Content
    ) {
        self.init(ID.allCases, id: \.self, content: content)
    }
}

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

public struct _OffsetIdentifiedElementOffsetPair<Element, Offset> {
    let element: Element
    let offset: Offset
    
    init(element: Element, offset: Offset) {
        self.element = element
        self.offset = offset
    }
}

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
