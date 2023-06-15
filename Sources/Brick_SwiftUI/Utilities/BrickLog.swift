//
//  BrickLog.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//
 
import os

public let log = Log()

public struct Log {
    private let logger: Logger
 
    public init(subsystem: String = "Brick", category: String = "Brick") {
        self.logger = Logger(subsystem: subsystem, category: category)
    }
}
 
public extension Log {
    func log(_ message: String, level: OSLogType = .default,  isPrivate: Bool = false) {
        if isPrivate {
            logger.log(level: level, "\(message, privacy: .private)")
        } else {
            logger.log(level: level, "\(message, privacy: .public)")
        }
    }
}
