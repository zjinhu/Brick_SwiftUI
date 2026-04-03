//
//  Task+.swift
//  Brick_SwiftUI
//
//  Created by iOS on 9/13/24.
//  Task 扩展 - 提供便捷的 Task 暂停功能 / Task extension - provides convenient Task sleep functionality
//

import SwiftUI

// MARK: - Task Sleep Extension / Task 睡眠扩展

/// Task 扩展 / Task extension
extension Task where Success == Never, Failure == Never {
    /// 以秒为单位暂停 Task / Pause Task in seconds
    /// - Parameter seconds: 秒数 / Seconds
    public static func sleep(seconds: TimeInterval) async throws {
        let nanoseconds = UInt64(seconds * 1_000_000_000)
        try? await Task.sleep(nanoseconds: nanoseconds)
    }
}
