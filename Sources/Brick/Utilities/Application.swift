//
//  Application.swift
//  SwiftBrick
//
//  Created by iOS on 2023/4/20.
//  Copyright © 2023 狄烨 . All rights reserved.
//

import Foundation

// MARK: - App信息 / App Information
extension Brick{
    public struct Application {
        
        /// 应用显示名称 / App display name
        public static var appDisplayName: String {
            return Bundle.main.infoDictionary?["CFBundleDisplayName"] as! String
        }
        
        /// 应用名称 / App name
        public static var appName: String {
            return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as! String
        }
        
        /// 应用 Bundle ID / App Bundle ID
        public static var appBundleID: String {
            return Bundle.main.bundleIdentifier!
        }
        
        /// 版本号 (如 1.0.0) / Version number (e.g. 1.0.0)
        public static var versionNumber: String {
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        }
        
        /// 构建号 / Build number
        public static var buildNumber: String {
            return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        }
        
        /// 完整版本号 (如 1.0.0 (100)) / Complete app version
        public static var completeAppVersion: String {
            return "\(Application.versionNumber) (\(Application.buildNumber))"
        }
    }
}

// MARK: - App 状态 / App State
extension Brick{
    public struct AppState {

        /// 是否为调试模式 / Whether in debug mode
        public static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
        }
        
        /// App 运行状态 / App run state
        public static var state: AppStateMode {
            if isDebug {
                return .debug
            } else if isTestFlight {
                return .testFlight
            } else {
                return .appStore
            }
        }
        
        /// App 状态模式 / App state mode
        public enum AppStateMode {
            case debug      // 调试模式 / Debug mode
            case testFlight // TestFlight 模式
            case appStore   // App Store 模式
        }
        
        /// 是否为 TestFlight / Whether is TestFlight
        fileprivate static var isTestFlight: Bool {
            if let receipt = Bundle.main.appStoreReceiptURL?.lastPathComponent, receipt == "sandboxReceipt" {
                return true
            }else{
                return false
            }
        }
        
    }
}
