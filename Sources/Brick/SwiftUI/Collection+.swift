//
//  Collection+.swift
//  Brick_SwiftUI
//
//  Created by 狄烨 on 2025.06.05.
//  Collection 扩展 - 提供集合的去重、计数、删除等操作 / Collection extension - provides collection operations like deduplication, counting, removal, etc.
//

import Foundation

// MARK: - Unique / 去重

/// Sequence 扩展 - 去重 / Sequence extension - deduplication
extension Sequence where Element: Hashable {
    /// 返回只包含唯一元素的数组 (按顺序) / Return an Array containing only the unique elements of self in order
    public func uniqued() -> [Element] {
        uniqued { $0 }
    }
}

/// Sequence 扩展 - 按属性去重 / Sequence extension - deduplicate by property
extension Sequence {
    /// 返回只包含唯一元素的数组 (按属性) / Return an Array containing only the unique elements of self, in order, where unique criteria is determined by the uniqueProperty block
    /// - Parameter uniqueProperty: 唯一性判断属性 / Unique criteria property
    /// - Returns: 去重后的数组 / Array with unique elements
    public func uniqued<T: Hashable>(_ uniqueProperty: (Element) -> T) -> [Element] {
        var seen: [T: Bool] = [:]
        return filter { seen.updateValue(true, forKey: uniqueProperty($0)) == nil }
    }
}

/// Array 扩展 - 原地去重 / Array extension - in-place deduplication
extension Array where Element: Hashable {
    /// 原地去重 / Modify self in-place such that only the unique elements of self in order are remaining
    public mutating func unique() {
        self = uniqued()
    }

    /// 按属性原地去重 / Modify self in-place such that only the unique elements of self in order where unique criteria is determined by the uniqueProperty block
    /// - Parameter uniqueProperty: 唯一性判断属性 / Unique criteria property
    public mutating func unique<T: Hashable>(_ uniqueProperty: (Element) -> T) {
        self = uniqued(uniqueProperty)
    }
}

// MARK: - Count / 计数

/// Collection 扩展 - 条件计数 / Collection extension - conditional count
extension Collection {
    /// Returns the number of elements of the sequence that satisfy the given
    /// predicate.
    ///
    /// ```swift
    /// let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    /// let shortNamesCount = cast.count { $0.count < 5 }
    /// print(shortNamesCount)
    /// // Prints "2"
    /// ```
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the element
    ///   should be included in the returned count.
    /// - Returns: A count of elements that satisfy the given predicate.
    /// - Complexity: O(_n_), where _n_ is the length of the sequence.
    /// Returns the number of elements of the sequence that satisfy the given
    /// predicate.
    ///
    /// ```swift
    /// let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    /// let shortNamesCount = cast.count { $0.count < 5 }
    /// print(shortNamesCount)
    /// // Prints "2"
    /// ```
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the element
    ///   should be included in the returned count.
    /// - Returns: A count of elements that satisfy the given predicate.
    /// - Complexity: O(_n_), where _n_ is the length of the sequence.
    /// 返回满足条件的元素数量 / Returns the number of elements of the sequence that satisfy the given predicate
    /// - Parameter predicate: 条件闭包 / Predicate closure
    /// - Returns: 满足条件的元素数量 / Count of elements that satisfy the predicate
    /// - Complexity: O(n), where n is the length of the sequence
    public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        try filter(predicate).count
    }
}

// MARK: - Removing All / 删除

/// RangeReplaceableCollection 扩展 - 条件删除 / RangeReplaceableCollection extension - conditional removal
extension RangeReplaceableCollection {
    /// Returns an array by removing all the elements that satisfy the given
    /// predicate.
    ///
    /// Use this method to remove every element in a collection that meets
    /// particular criteria. This example removes all the odd values from an array
    /// of numbers:
    ///
    /// ```swift
    /// var numbers = [5, 6, 7, 8, 9, 10, 11]
    /// let removedNumbers = numbers.removingAll(where: { $0 % 2 == 1 })
    ///
    /// // numbers == [6, 8, 10]
    /// // removedNumbers == [5, 7, 9, 11]
    /// ```
    ////
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the element
    ///   should be removed from the collection.
    /// - Returns: A collection of the elements that are removed.
    /// 删除所有满足条件的元素并返回 / Returns an array by removing all the elements that satisfy the given predicate
    /// - Parameter predicate: 条件闭包 / Predicate closure
    /// - Returns: 被删除的元素集合 / Collection of removed elements
    public mutating func removingAll(where predicate: (Element) throws -> Bool) rethrows -> Self {
        let result = try filter(predicate)
        try removeAll(where: predicate)
        return result
    }
}

/// RangeReplaceableCollection 扩展 - 按值删除 / RangeReplaceableCollection extension - remove by value
extension RangeReplaceableCollection where Element: Equatable, Index == Int {
    /// 按值删除元素 / Removes given element by value from the collection
    /// - Parameter element: 要删除的元素 / Element to remove
    /// - Returns: 是否成功删除 / true if removed; false otherwise
    @discardableResult
    public mutating func remove(_ element: Element) -> Bool {
        for (index, elementToCompare) in enumerated() where element == elementToCompare {
            remove(at: index)
            return true
        }
        return false
    }

    /// 批量按值删除元素 / Removes given elements by value from the collection
    /// - Parameter elements: 要删除的元素数组 / Array of elements to remove
    public mutating func remove(_ elements: [Element]) {
        elements.forEach { remove($0) }
    }

    // MARK: - Non-mutating / 非修改

    /// 按值删除 (非修改) / Removes given element by value from the collection (non-mutating)
    /// - Parameter element: 要删除的元素 / Element to remove
    /// - Returns: 新集合 / New collection
    public func removing(_ element: Element) -> Self {
        var copy = self
        copy.remove(element)
        return copy
    }

    /// 批量按值删除 (非修改) / Removes given elements by value from the collection (non-mutating)
    /// - Parameter elements: 要删除的元素数组 / Array of elements to remove
    /// - Returns: 新集合 / New collection
    public func removing(_ elements: [Element]) -> Self {
        var copy = self
        copy.remove(elements)
        return copy
    }

    /// 移动元素到指定位置 / Move an element in self to a specific index
    /// - Parameters:
    ///   - element: 要移动的元素 / Element to move
    ///   - index: 新位置索引 / New location index
    /// - Returns: 是否成功移动 / true if moved; otherwise, false
    @discardableResult
    public mutating func move(_ element: Element, to index: Int) -> Bool {
        guard remove(element) else {
            return false
        }

        insert(element, at: index)
        return true
    }
}

// MARK: - First / 首个元素

/// Sequence 扩展 - 按 KeyPath 查找首个 / Sequence extension - find first by KeyPath
extension Sequence {
    /// 返回满足所有 KeyPath 条件的首个元素 / Returns the first element of the sequence that satisfies the given predicate
    /// - Parameter keyPaths: KeyPath 数组 / Array of keyPaths
    /// - Returns: 满足条件的首个元素或 nil / First element that satisfies predicate, or nil
    func first(_ keyPaths: KeyPath<Element, Bool>...) -> Element? {
        first { element in
            keyPaths.allSatisfy {
                element[keyPath: $0]
            }
        }
    }

    /// 返回满足所有 KeyPath 条件的首个元素 / Returns the first element of the sequence that satisfies the given predicate
    /// - Parameter keyPaths: KeyPath 数组 / Array of keyPaths
    /// - Returns: 满足条件的首个元素或 nil / First element that satisfies predicate, or nil
    func first(_ keyPaths: [KeyPath<Element, Bool>]) -> Element? {
        first { element in
            keyPaths.allSatisfy {
                element[keyPath: $0]
            }
        }
    }
}

// MARK: - NSPredicate / NSPredicate 过滤

/// Collection 扩展 - NSPredicate 过滤 / Collection extension - NSPredicate filtering
extension Collection {
    /// 使用 NSPredicate 过滤 / Returns an array containing, in order, the elements of the sequence that satisfy the given predicate
    /// - Parameter predicate: NSPredicate / NSPredicate
    /// - Returns: 过滤后的数组 / Filtered array
    public func filter(with predicate: NSPredicate) -> [Element] {
        filter(predicate.evaluate(with:))
    }

    /// 使用 NSPredicate 查找首个 / Returns the first element of the sequence that satisfies the given predicate
    /// - Parameter predicate: NSPredicate / NSPredicate
    /// - Returns: 首个满足条件的元素或 nil / First element that satisfies predicate, or nil
    public func first(with predicate: NSPredicate) -> Element? {
        first(where: predicate.evaluate(with:))
    }
}
