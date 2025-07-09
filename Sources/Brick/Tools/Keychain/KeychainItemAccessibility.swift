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
 This enum defines the various access scopes that a keychain
 item can use. The names follow certain conventions that are
 defined in the list below:
 
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
    
    case afterFirstUnlock
    case afterFirstUnlockThisDeviceOnly
    case whenPasscodeSetThisDeviceOnly
    case whenUnlocked
    case whenUnlockedThisDeviceOnly
    
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
