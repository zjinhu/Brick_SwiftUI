//
//  KeychainWrapper.swift
//
//  Created by iOS on 2023/6/28.
//

import Foundation

private let paramSecMatchLimit = kSecMatchLimit as String
private let paramSecReturnData = kSecReturnData as String
private let paramSecReturnPersistentRef = kSecReturnPersistentRef as String
private let paramSecValueData = kSecValueData as String
private let paramSecAttrAccessible = kSecAttrAccessible as String
private let paramSecClass = kSecClass as String
private let paramSecAttrService = kSecAttrService as String
private let paramSecAttrGeneric = kSecAttrGeneric as String
private let paramSecAttrAccount = kSecAttrAccount as String
private let paramSecAttrAccessGroup = kSecAttrAccessGroup as String
private let paramSecReturnAttributes = kSecReturnAttributes as String


/**
 钥匙串包装器/Keychain wrapper
 简化设备钥匙串访问的类，设计为使钥匙串访问更像使用NSUserDefaults。
 This class help make device keychain access easier in Swift.
 It is designed to make accessing the Keychain services more
 like using `NSUserDefaults`, which is much more familiar to
 developers in general.
 
 serviceName用于kSecAttrService，唯一标识钥匙串访问。
 如果未指定名称，默认为当前bundle标识符。
 `serviceName` is used for `kSecAttrService`, which uniquely
 identifies keychain accessors. If no name is specified, the
 value defaults to the current bundle identifier.
 
 accessGroup用于kSecAttrAccessGroup，用于标识钥匙串条目所属的访问组。
 允许在不同应用之间共享钥匙串访问。
 `accessGroup` is used for `kSecAttrAccessGroup`. This value
 is used to identify which keychain access group an entry is
 belonging to. This allows you to use `KeychainWrapper` with
 shared keychain access between different applications.
 */
@MainActor 
open class KeychainWrapper {
    
    
    // MARK: - Initialization/初始化
    
    /// 创建标准实例/Create a standard instance of this class.
    private convenience init() {
        let id = Bundle.main.bundleIdentifier
        let fallback = "com.swiftkit.keychain"
        self.init(serviceName: id ?? fallback)
    }
    
    /// 创建自定义实例/Create a custom instance of this class.
    ///
    /// serviceName用于唯一标识存储在钥匙串中的每个键。
    /// The `serviceName` is used to uniquely identify every
    /// key that has been stored in the keychain, using this
    /// wrapper instance.
    ///
    /// 在需要共享钥匙串访问的应用之间使用匹配的访问组。
    /// Use matching access groups between applications when
    /// you want to allow shared keychain access.
    ///
    /// - Parameters:
    ///   - serviceName: 服务名称/Service name to use for this instance
    ///   - accessGroup: 可选的访问组/Optional access group for this instance
    public init(
        serviceName: String,
        accessGroup: String? = nil
    ) {
        self.serviceName = serviceName
        self.accessGroup = accessGroup
    }
    
    
    // MARK: - Properties/属性
    
    /// 标准钥匙串包装器实例/A standard keychain wrapper instance.
    public static let standard = KeychainWrapper()
    
    /// 服务名称/Service name to use for this instance
    private let serviceName: String
    
    /// 可选的访问组/Optional access group for this instance
    private let accessGroup: String?
    
    
    // MARK: - KeychainReader/钥匙串读取
    
    /// 获取指定键的可访问性/Get accessibility for specified key
    /// - Parameter key: 键名/Key name
    /// - Returns: 可访问性值或nil/Accessibility value or nil
    open func accessibility(for key: String) -> KeychainItemAccessibility? {
        var dict = setupKeychainQueryDictionary(forKey: key)
        var result: AnyObject?
        dict.removeValue(forKey: paramSecAttrAccessible)
        dict[paramSecMatchLimit] = kSecMatchLimitOne
        dict[paramSecReturnAttributes] = kCFBooleanTrue
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(dict as CFDictionary, UnsafeMutablePointer($0))
        }
        if status == noErr,
            let dict = result as? [String: AnyObject],
            let val = dict[paramSecAttrAccessible] as? String {
            return KeychainItemAccessibility.accessibilityForAttributeValue(val as CFString)
        }
        return nil
    }
    
    /// 读取布尔值/Read boolean value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 布尔值或nil/Boolean value or nil
    open func bool(for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Bool? {
        number(for: key, with: accessibility)?.boolValue
    }
    
    /// 读取数据/Read data
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 数据或nil/Data or nil
    open func data(for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Data? {
        var dict = setupKeychainQueryDictionary(forKey: key, with: accessibility)
        var result: AnyObject?
        dict[paramSecMatchLimit] = kSecMatchLimitOne
        dict[paramSecReturnData] = kCFBooleanTrue
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(dict as CFDictionary, UnsafeMutablePointer($0))
        }
        return status == noErr ? result as? Data: nil
    }
    
    /// 读取双精度浮点数/Read double value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 双精度浮点数或nil/Double value or nil
    open func double(for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Double? {
        number(for: key, with: accessibility)?.doubleValue
    }
    
    /// 读取浮点数/Read float value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 浮点数或nil/Float value or nil
    open func float(for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Float? {
        number(for: key, with: accessibility)?.floatValue
    }
    
    /// 检查是否存在值/Check if value exists
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否存在/Whether exists
    open func hasValue(for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Bool {
        data(for: key, with: accessibility) != nil
    }
    
    /// 读取整数/Read integer value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 整数或nil/Integer value or nil
    open func integer(for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Int? {
        number(for: key, with: accessibility)?.intValue
    }
    
    /// 读取NSNumber/Read NSNumber
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: NSNumber或nil/NSNumber or nil
    open func number(for key: String, with accessibility: KeychainItemAccessibility? = nil) -> NSNumber? {
        object(for: key, with: accessibility)
    }
    
    /// 读取对象/Read object
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 对象或nil/Object or nil
    open func object<T: NSObject & NSCoding>(for key: String, with accessibility: KeychainItemAccessibility? = nil) -> T? {
        guard let keychainData = data(for: key, with: accessibility) else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: keychainData)
    }
    
    /// 读取字符串/Read string value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 字符串或nil/String value or nil
    open func string(for key: String, with accessibility: KeychainItemAccessibility? = nil) -> String? {
        guard let keychainData = data(for: key, with: accessibility) else { return nil }
        return String(data: keychainData, encoding: String.Encoding.utf8) as String?
    }
    
    /// 读取数据引用/Read data reference
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 数据引用或nil/Data reference or nil
    open func dataRef(for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Data? {
        var dict = setupKeychainQueryDictionary(forKey: key, with: accessibility)
        var result: AnyObject?
        dict[paramSecMatchLimit] = kSecMatchLimitOne
        dict[paramSecReturnPersistentRef] = kCFBooleanTrue
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(dict as CFDictionary, UnsafeMutablePointer($0))
        }
        return status == noErr ? result as? Data: nil
    }
    
    
    // MARK: - KeychainWriter/钥匙串写入
    
    /// 保存整数/Save integer value
    /// - Parameter value: 整数值/Integer value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func set(_ value: Int, for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Bool {
        set(NSNumber(value: value), for: key, with: accessibility)
    }
    
    /// 保存浮点数/Save float value
    /// - Parameter value: 浮点数值/Float value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func set(_ value: Float, for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Bool {
        set(NSNumber(value: value), for: key, with: accessibility)
    }
    
    /// 保存双精度浮点数/Save double value
    /// - Parameter value: 双精度浮点数值/Double value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func set(_ value: Double, for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Bool {
        set(NSNumber(value: value), for: key, with: accessibility)
    }
    
    /// 保存布尔值/Save boolean value
    /// - Parameter value: 布尔值/Boolean value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func set(_ value: Bool, for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Bool {
        set(NSNumber(value: value), for: key, with: accessibility)
    }
    
    /// 保存字符串/Save string value
    /// - Parameter value: 字符串值/String value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func set(_ value: String, for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return set(data, for: key, with: accessibility)
    }
    
    /// 保存NSCoding对象/Save NSCoding object
    /// - Parameter value: NSCoding对象/NSCoding object
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func set(_ value: NSCoding, for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Bool {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false) else { return false }
        return set(data, for: key, with: accessibility)
    }
    
    /// 保存数据/Save data
    /// - Parameter value: 数据/Data value
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func set(_ value: Data, for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Bool {
        var dict: [String: Any] = setupKeychainQueryDictionary(forKey: key, with: accessibility)
        dict[paramSecValueData] = value
        
        if let accessibility = accessibility {
            dict[paramSecAttrAccessible] = accessibility.keychainAttrValue
        } else {
            // 分配默认保护 - 保护钥匙串条目使其仅在设备解锁时有效/Assign default protection - Protect the keychain entry so it's only valid when the device is unlocked
            dict[paramSecAttrAccessible] = KeychainItemAccessibility.whenUnlocked.keychainAttrValue
        }
        
        let status = SecItemAdd(dict as CFDictionary, nil)
        if status == errSecDuplicateItem {
            return update(value, forKey: key, with: accessibility)
        }
        return status == errSecSuccess
    }

    /// 删除指定键的值/Delete value for specified key
    /// - Parameter key: 键名/Key name
    /// - Parameter accessibility: 可访问性选项/Accessibility option
    /// - Returns: 是否成功/Whether successful
    @discardableResult
    open func removeObject(for key: String, with accessibility: KeychainItemAccessibility? = nil) -> Bool {
        let keychainQueryDictionary: [String: Any] = setupKeychainQueryDictionary(forKey: key, with: accessibility)
        let status = SecItemDelete(keychainQueryDictionary as CFDictionary)
        return status == errSecSuccess
    }
    
    /// 删除所有由本包装器添加的键/Remove all items from the device keychain, that were added by this wrapper.
    /// - Returns: 是否成功/Whether successful
    open func removeAllKeys() -> Bool {
        var dict: [String: Any] = [paramSecClass: kSecClassGenericPassword]
        dict[paramSecAttrService] = serviceName
        if let accessGroup {
            dict[paramSecAttrAccessGroup] = accessGroup
        }
        let status = SecItemDelete(dict as CFDictionary)
        return status == errSecSuccess
    }
    
    /// 删除设备上的所有钥匙串数据，包括非本包装器添加的条目。/Remove all items from the device keychain, including entries that were not added by this wrapper.
    ///
    /// 警告：这将删除所有数据。/Warning: This will remove all data from the store.
    open class func wipeKeychain() {
        deleteKeychainSecClass(kSecClassGenericPassword)    // Generic password items
        deleteKeychainSecClass(kSecClassInternetPassword)   // Internet password items
        deleteKeychainSecClass(kSecClassCertificate)        // Certificate items
        deleteKeychainSecClass(kSecClassKey)                // Cryptographic key items
        deleteKeychainSecClass(kSecClassIdentity)           // Identity items
    }
}


// MARK: - Private Methods

private extension KeychainWrapper {
    
    /// Remove all items for a given Keychain Item Class.
    @discardableResult
    class func deleteKeychainSecClass(_ secClass: AnyObject) -> Bool {
        let query = [paramSecClass: secClass]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    /// Update all data that's associated with a certain key.
    ///
    /// Any existing data will be overwritten.
    func update(
        _ value: Data,
        forKey key: String,
        with accessibility: KeychainItemAccessibility? = nil
    ) -> Bool {
        var keychainQueryDictionary: [String: Any] = setupKeychainQueryDictionary(forKey: key, with: accessibility)
        let updateDictionary = [paramSecValueData: value]
        if let accessibility = accessibility {
            keychainQueryDictionary[paramSecAttrAccessible] = accessibility.keychainAttrValue
        }
        let status = SecItemUpdate(keychainQueryDictionary as CFDictionary, updateDictionary as CFDictionary)
        return status == errSecSuccess
    }
    
    /// Setup the keychain query dictionary.
    ///
    /// The dictionary is used to access the keychain on iOS
    /// for a certain key, taking into account service names
    /// and access groups, whenever set.
    ///
    /// - Parameters:
    ///   - forKey: The key this query is for.
    ///   - accessibility: Optional keychain accessibility.
    ///
    /// - returns: A dictionary with all properties needed to access the keychain on iOS.
    func setupKeychainQueryDictionary(
        forKey key: String,
        with accessibility: KeychainItemAccessibility? = nil
    ) -> [String: Any] {
        var dict: [String: Any] = [paramSecClass: kSecClassGenericPassword]
        dict[paramSecAttrService] = serviceName
        if let accessibility = accessibility {
            dict[paramSecAttrAccessible] = accessibility.keychainAttrValue
        }
        if let accessGroup = self.accessGroup {
            dict[paramSecAttrAccessGroup] = accessGroup
        }
        let encodedIdentifier = key.data(using: String.Encoding.utf8)
        dict[paramSecAttrGeneric] = encodedIdentifier
        dict[paramSecAttrAccount] = encodedIdentifier
        return dict
    }
}
