//
//  BrickLog.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//  日志工具 - 基于 os.log 的统一日志管理 / Logging utility based on os.log for unified log management
//  支持多级别日志输出 (debug, info, warning, error, fault等) / Supports multiple log levels (debug, info, warning, error, fault, etc.)
//

import os
import Foundation

/// BrickLog 日志结构体 / BrickLog log structure
/// 提供基于 os.log 的日志功能，支持多种日志级别 / Provides log functionality based on os.log, supporting multiple log levels
public typealias Log = BrickLog

public struct BrickLog: @unchecked Sendable {
    private let logger: Logger
    
    /// Logger管理器结构体 / Logger manager structure
    struct LoggerManager: @unchecked Sendable {
        let logger: BrickLog
        
        init() {
            self.logger = BrickLog.create()
        }
    }
    
    /// 全局静态Logger管理器 / Global static Logger manager
    static let shared = LoggerManager()
    
    /// 初始化 BrickLog / Initialize BrickLog
    /// - Parameters:
    ///   - subsystem: 子系统标识符 / Subsystem identifier
    ///   - category: 日志分类 / Log category
    public init(subsystem: String = "BrickLog",
                category: String = "BrickLog") {
        self.logger = Logger(subsystem: subsystem, category: category)
    }
    
    /// 创建 BrickLog 实例 / Create BrickLog instance
    /// - Parameter category: 日志分类 / Log category
    /// - Returns: BrickLog 实例 / BrickLog instance
    public static func create(category: String = "BrickLog") -> BrickLog {
        let subsystem = Bundle.main.bundleIdentifier ?? "BrickLog"
        return BrickLog(subsystem: subsystem, category: category)
    }
}

// MARK: - Instance Methods / 实例方法

/// 实例方法扩展 / Instance method extension
public extension BrickLog {
    /// 通用的日志输出 / General log output
    /// - Parameters:
    ///   - message: 日志消息 / Log message
    ///   - level: 日志级别 / Log level
    ///   - isPrivate: 是否为私密内容 / Whether is private content
    func log(_ message: String, level: OSLogType = .default,  isPrivate: Bool = false) {
        if isPrivate {
            logger.log(level: level, "🎾\(message, privacy: .private)")
        } else {
            logger.log(level: level, "🎾\(message, privacy: .public)")
        }
    }
    
    /// 默认日志级别 / Default log level
    /// - Parameter message: 日志消息 / Log message
    func log(_ message: String){
        logger.log("🎾\(message, privacy: .public)")
    }
    
    /// 信息级日志 - 捕获可能对故障排除有用但不是必需的信息 / Info level log - capture information that may be useful for troubleshooting but not essential
    /// - Parameter message: 日志消息 / Log message
    func info(_ message: String){
        logger.info("🔵\(message, privacy: .public)")
    }
    
    /// 调试级日志 - 在开发环境中进行主动调试时使用 / Debug level log - used for active debugging in development environment
    /// - Parameter message: 日志消息 / Log message
    func debug(_ message: String){
        logger.debug("🟢\(message, privacy: .public)")
    }
    
    /// 跟踪级日志 - 相当于debug方法 / Trace level log - equivalent to debug method
    /// - Parameter message: 日志消息 / Log message
    func trace(_ message: String){
        logger.trace("🟤\(message, privacy: .public)")
    }
    
    /// 通知级日志 / Notice level log
    /// - Parameter message: 日志消息 / Log message
    func notice(_ message: String){
        logger.notice("🟣\(message, privacy: .public)")
    }
    
    /// 警告级日志 - 用于报告意外非致命故障 / Warning level log - used to report unexpected non-fatal failures
    /// - Parameter message: 日志消息 / Log message
    func warning(_ message: String){
        logger.warning("🟡\(message, privacy: .public)")
    }
    
    /// 错误级日志 - 用于报告严重错误和失败 / Error level log - used to report serious errors and failures
    /// - Parameter message: 日志消息 / Log message
    func error(_ message: String){
        logger.error("🔴\(message, privacy: .public)")
    }
    
    /// 严重错误级日志 - 故障级消息等效 / Critical level log - equivalent to fault level message
    /// - Parameter message: 日志消息 / Log message
    func critical(_ message: String){
        logger.critical("⚫️\(message, privacy: .public)")
    }
    
    /// 故障级日志 - 仅用于捕获系统级或多进程错误 / Fault level log - only for capturing system-level or multi-process errors
    /// - Parameter message: 日志消息 / Log message
    func fault(_ message: String){
        logger.fault("❌\(message, privacy: .public)")
    }
}

// MARK: - Static Methods / 静态方法

/// 静态方法扩展 / Static method extension
public extension BrickLog {
    
    /// 静态信息级日志 / Static info level log
    /// - Parameter message: 日志消息 / Log message
    static func info(_ message: String) {
        shared.logger.info(message)
    }
    
    /// 静态调试级日志 / Static debug level log
    /// - Parameter message: 日志消息 / Log message
    static func debug(_ message: String) {
        shared.logger.debug(message)
    }
    
    /// 静态警告级日志 / Static warning level log
    /// - Parameter message: 日志消息 / Log message
    static func warning(_ message: String) {
        shared.logger.warning(message)
     }
    
    /// 静态错误级日志 / Static error level log
    /// - Parameter message: 日志消息 / Log message
    static func error(_ message: String) {
        shared.logger.error(message)
    }
    
    /// 静态故障级日志 / Static fault level log
    /// - Parameter message: 日志消息 / Log message
    static func fault(_ message: String) {
        shared.logger.fault(message)
    }
}