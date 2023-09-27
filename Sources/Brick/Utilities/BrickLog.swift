//
//  BrickLog.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//
 
import os

public let logger = BrickLog()

public struct BrickLog {
    private let logger: Logger
 
    public init(subsystem: String = "Brick", category: String = "Brick") {
        self.logger = Logger(subsystem: subsystem, category: category)
    }
}
 
public extension BrickLog {
    func log(_ message: String, level: OSLogType = .default,  isPrivate: Bool = false) {
        if isPrivate {
            logger.log(level: level, "\(message, privacy: .private)")
        } else {
            logger.log(level: level, "\(message, privacy: .public)")
        }
    }
    
    func log(_ message: String){
        logger.log("⚪️\(message)")
    }
    func trace(_ message: String){
        logger.trace("🟤\(message)")
    }
    func debug(_ message: String){
        logger.debug("🟢\(message)")
    }
    func info(_ message: String){
        logger.info("🔵\(message)")
    }
    func notice(_ message: String){
        logger.notice("🟣\(message)")
    }
    func warning(_ message: String){
        logger.warning("🟡\(message)")
    }
    func error(_ message: String){
        logger.error("🔴\(message)")
    }
    func critical(_ message: String){
        logger.critical("⚫️\(message)")
    }
    func fault(_ message: String){
        logger.fault("❌\(message)")
    }
}
