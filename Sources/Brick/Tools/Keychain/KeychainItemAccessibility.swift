//
//  KeychainItemAccessibility.swift
//
//  Created by iOS on 2023/6/28.
//

import Foundation

protocol KeychainAttrRepresentable {
    
    var keychainAttrValue: CFString { get }
}

/**
 钥匙串项目可访问性/Keychain item accessibility
 定义钥匙串项目的各种访问范围。
 This enum defines the various access scopes that a keychain
 item can use. The names follow certain conventions that are
 defined in the list below:
 
 - afterFirstUnlock: 设备重启后不可访问，直到用户首次解锁后可用。此选项适用于需要在后台应用或进程中可用的项目。
 - whenPasscodeSet: 只有在用户已解锁设备且设置了设备密码时才可访问。没有密码则无法在设备上存储项目。
 - whenUnlocked: 只有在用户解锁设备时才可访问。此选项适用于仅在应用活跃时使用的项目。
 - *ThisDeviceOnly: 不会包含在加密备份中，因此在从备份恢复应用后将不可用。
 
 * `afterFirstUnlock`
 The attribute cannot be accessed after a restart, until the
 device has been unlocked once by the user. After this first
 unlock, the items remains accessible until the next restart.
 This is recommended for items that must be available to any
 background applications or processes.
 
 * `whenPasscodeSet`
 The attribute can only be accessed when the device has been
 unlocked by the user and a device passcode is set. No items
 can be stored on device if a passcode is not set. Disabling
 the passcode will delete all items.
 
 * `whenUnlocked`
 The attribute can only be accessed when the device has been
 unlocked by the user. This is recommended for items that we
 only mean to use when the application is active.
 
 * `*ThisDeviceOnly`
 The attribute will not be included in encrypted backup, and
 are thus not available after restoring apps from backups on
 a different device.
 */
@MainActor
public enum KeychainItemAccessibility : Sendable{
    
    /// 首次解锁后可访问/After first unlock
    case afterFirstUnlock
    /// 首次解锁后可访问，仅限本设备/After first unlock, this device only
    case afterFirstUnlockThisDeviceOnly
    /// 设置密码后可访问，仅限本设备/When passcode set, this device only
    case whenPasscodeSetThisDeviceOnly
    /// 解锁时可访问/When unlocked
    case whenUnlocked
    /// 解锁时可访问，仅限本设备/When unlocked, this device only
    case whenUnlockedThisDeviceOnly
    
    /// 根据属性值获取可访问性/Get accessibility from attribute value
    /// - Parameter keychainAttrValue: 钥匙串属性值/Keychain attribute value
    /// - Returns: 可访问性值或nil/Accessibility value or nil
    static func accessibilityForAttributeValue(_ keychainAttrValue: CFString) -> KeychainItemAccessibility? {
        keychainItemAccessibilityLookup.first { $0.value == keychainAttrValue }?.key
    }
}

@MainActor
private let keychainItemAccessibilityLookup: [KeychainItemAccessibility: CFString] = [
    .afterFirstUnlock: kSecAttrAccessibleAfterFirstUnlock,
    .afterFirstUnlockThisDeviceOnly: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
    .whenPasscodeSetThisDeviceOnly: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
    .whenUnlocked: kSecAttrAccessibleWhenUnlocked,
    .whenUnlockedThisDeviceOnly: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
]

@MainActor
extension KeychainItemAccessibility: @preconcurrency KeychainAttrRepresentable {
    
    public var keychainAttrValue: CFString {
        keychainItemAccessibilityLookup[self]!
    }
}
