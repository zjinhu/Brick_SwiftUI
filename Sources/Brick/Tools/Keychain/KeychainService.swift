//
//  StandardKeychainService.swift
//
//  Created by iOS on 2023/6/28.
//
//

import Foundation

/**
 钥匙串服务/Keychain service
 用于读写设备钥匙串的类，使用KeychainWrapper。
 This class can be used to read from and write to the device
 keychain, using a ``KeychainWrapper``.
 */
@MainActor
open class KeychainService {
    
    /// 初始化钥匙串服务/Initialize keychain service
    /// - Parameter wrapper: 钥匙串包装器，默认为标准实例/Keychain wrapper, default is standard instance
    public init(
        wrapper: KeychainWrapper = .standard
    ) {
        self.wrapper = wrapper
    }
    
    private let wrapper: KeychainWrapper
    
    
    // MARK: - KeychainReader/钥匙串读取
    
    /// 获取指定键的可访问性/Get accessibility for specified key
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 可访问性值/Accessibility value
    open func accessibility(for key: String) -> KeychainItemAccessibility? {
        wrapper.accessibility(for: key)
    }
    
    /// 读取布尔值/Read boolean value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 布尔值/Boolean value
    open func bool(for key: String, with accessibility: KeychainItemAccessibility?) -> Bool? {
        wrapper.bool(for: key, with: accessibility)
    }
    
    /// 读取数据/Read data
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 数据/Data
    open func data(for key: String, with accessibility: KeychainItemAccessibility?) -> Data? {
        wrapper.data(for: key, with: accessibility)
    }
    
    /// 读取数据引用/Read data reference
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 数据引用/Data reference
    open func dataRef(for key: String, with accessibility: KeychainItemAccessibility?) -> Data? {
        wrapper.dataRef(for: key, with: accessibility)
    }
    
    /// 读取双精度浮点数/Read double value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 双精度浮点数/Double value
    open func double(for key: String, with accessibility: KeychainItemAccessibility?) -> Double? {
        wrapper.double(for: key, with: accessibility)
    }
    
    /// 读取浮点数/Read float value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 浮点数/Float value
    open func float(for key: String, with accessibility: KeychainItemAccessibility?) -> Float? {
        wrapper.float(for: key, with: accessibility)
    }
    
    /// 检查是否存在值/Check if value exists
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否存在/Whether exists
    open func hasValue(for key: String, with accessibility: KeychainItemAccessibility?) -> Bool {
        wrapper.hasValue(for: key, with: accessibility)
    }
    
    /// 读取整数/Read integer value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 整数/Integer value
    open func integer(for key: String, with accessibility: KeychainItemAccessibility?) -> Int? {
        wrapper.integer(for: key, with: accessibility)
    }
    
    /// 读取字符串/Read string value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 字符串/String value
    open func string(for key: String, with accessibility: KeychainItemAccessibility?) -> String? {
        wrapper.string(for: key, with: accessibility)
    }
    
    
    // MARK: - KeychainWriter/钥匙串写入
    
    /// 删除指定键的值/Delete value for specified key
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func removeObject(for key: String, with accessibility: KeychainItemAccessibility?) -> Bool {
        wrapper.removeObject(for: key, with: accessibility)
    }
    
    /// 删除所有键/Delete all keys
    /// - Returns: 是否成功/Whether successful
    open func removeAllKeys() -> Bool {
        wrapper.removeAllKeys()
    }
    
    /// 保存布尔值/Save boolean value
    /// - Parameter value: 布尔值/Boolean value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func set(_ value: Bool, for key: String, with accessibility: KeychainItemAccessibility?) -> Bool {
        wrapper.set(value, for: key, with: accessibility)
    }
    
    /// 保存数据/Save data
    /// - Parameter value: 数据/Data value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func set(_ value: Data, for key: String, with accessibility: KeychainItemAccessibility?) -> Bool {
        wrapper.set(value, for: key, with: accessibility)
    }
    
    /// 保存双精度浮点数/Save double value
    /// - Parameter value: 双精度浮点数/Double value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func set(_ value: Double, for key: String, with accessibility: KeychainItemAccessibility?) -> Bool {
        wrapper.set(value, for: key, with: accessibility)
    }
    
    /// 保存浮点数/Save float value
    /// - Parameter value: 浮点数/Float value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func set(_ value: Float, for key: String, with accessibility: KeychainItemAccessibility?) -> Bool {
        wrapper.set(value, for: key, with: accessibility)
    }
    
    /// 保存整数/Save integer value
    /// - Parameter value: 整数/Integer value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func set(_ value: Int, for key: String, with accessibility: KeychainItemAccessibility?) -> Bool {
        wrapper.set(value, for: key, with: accessibility)
    }
    
    /// 保存NSCoding对象/Save NSCoding object
    /// - Parameter value: NSCoding对象/NSCoding object
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func set(_ value: NSCoding, for key: String, with accessibility: KeychainItemAccessibility?) -> Bool {
        wrapper.set(value, for: key, with: accessibility)
    }
    
    /// 保存字符串/Save string value
    /// - Parameter value: 字符串/String value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func set(_ value: String, for key: String, with accessibility: KeychainItemAccessibility?) -> Bool {
        wrapper.set(value, for: key, with: accessibility)
    }
}

public extension KeychainService {
    
    /// 共享服务单例/A shared service singleton.
    static var shared: KeychainService { .init() }
}
