//
//  SwiftUIView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 9/13/24.
//

import SwiftUI

extension Task where Success == Never, Failure == Never {
    // 扩展 Task，支持以秒为单位进行暂停
    public static func sleep(seconds: TimeInterval) async throws {
        let nanoseconds = UInt64(seconds * 1_000_000_000)
        try? await Task.sleep(nanoseconds: nanoseconds)
    }
}
