//
//  BrickLog.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//
 
import os
import Foundation

public typealias Log = BrickLog
public struct BrickLog: @unchecked Sendable {
    private let logger: Logger
 
    public init(subsystem: String = "BrickLog",
                category: String = "BrickLog") {
        self.logger = Logger(subsystem: subsystem, category: category)
    }
    
    public static func create(category: String = "BrickLog") -> BrickLog {
        // 尝试获取主Bundle的identifier，如果失败则使用默认值
        let subsystem = Bundle.main.bundleIdentifier ?? "BrickLog"
        return BrickLog(subsystem: subsystem, category: category)
    }
}
 
public extension BrickLog {
    /// 全局静态Logger管理器
    static let shared = LoggerManager()
    
    class LoggerManager : @unchecked Sendable{
        private let subsystem: String
        private var loggers: [String: Logger] = [:]
        private let queue = DispatchQueue(label: "com.brick.logger.queue")
        
        init() {
            // 获取正确的subsystem
            self.subsystem = Bundle.main.bundleIdentifier ?? "BrickLog"
        }
        
        func logger(for category: String) -> Logger {
            queue.sync {
                if let existing = loggers[category] {
                    return existing
                }
                let new = Logger(subsystem: subsystem, category: category)
                loggers[category] = new
                return new
            }
        }
    }
}

public extension BrickLog {
    func log(_ message: String, level: OSLogType = .default,  isPrivate: Bool = false) {
        if isPrivate {
            logger.log(level: level, "🎾\(message, privacy: .private)")
        } else {
            logger.log(level: level, "🎾\(message, privacy: .public)")
        }
    }
    //默认的日志级别
    func log(_ message: String){
        logger.log("🎾\(message, privacy: .public)")
    }
    //调用此函数来捕获可能对故障排除有用但不是必需的信息
    func info(_ message: String){
        logger.info("🔵\(message, privacy: .public)")
    }
    //在开发环境中进行主动调试时使用的调试级消息
    func debug(_ message: String){
        logger.debug("🟢\(message, privacy: .public)")
    }
    //相当于debug方法
    func trace(_ message: String){
        logger.trace("🟤\(message, privacy: .public)")
    }
    func notice(_ message: String){
        logger.notice("🟣\(message, privacy: .public)")
    }
    //用于报告意外非致命故障的警告级别消息
    func warning(_ message: String){
        logger.warning("🟡\(message, privacy: .public)")
    }
    //用于报告严重错误和失败的错误级别消息
    func error(_ message: String){
        logger.error("🔴\(message, privacy: .public)")
    }
    //故障级消息等效
    func critical(_ message: String){
        logger.critical("⚫️\(message, privacy: .public)")
    }
    //故障级消息，仅用于捕获系统级或多进程错误
    func fault(_ message: String){
        logger.fault("❌\(message, privacy: .public)")
    }
}

public extension BrickLog {
    /// 静态日志方法，自动管理Logger实例
    static func log(_ message: String,
                   category: String = "BrickLog",
                   level: OSLogType = .default,
                   isPrivate: Bool = false) {
        let logger = shared.logger(for: category)
        logger.log(level: level, "🎾 \(message, privacy: .public)")
    }
    
    static func info(_ message: String, category: String = "BrickLog") {
        let logger = shared.logger(for: category)
        logger.info("🔵 \(message, privacy: .public)")
    }
    
    static func debug(_ message: String, category: String = "BrickLog") {
        let logger = shared.logger(for: category)
        logger.debug("🟢 \(message, privacy: .public)")
    }
    
    static func warning(_ message: String, category: String = "BrickLog") {
        let logger = shared.logger(for: category)
        logger.warning("🟡 \(message, privacy: .public)")
     }
    
    static func error(_ message: String, category: String = "BrickLog") {
        let logger = shared.logger(for: category)
        logger.error("🔴 \(message, privacy: .public)")
    }
    
    static func fault(_ message: String, category: String = "BrickLog") {
        let logger = shared.logger(for: category)
        logger.fault("❌ \(message, privacy: .public)")
    }
}
