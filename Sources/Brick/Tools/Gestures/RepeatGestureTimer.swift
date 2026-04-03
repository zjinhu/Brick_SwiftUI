//
//  RepeatGestureTimer.swift
//
//  Created by iOS on 2023/6/28.
//
//

import Foundation

/**
 手势重复计时器/Repeat gesture timer
 用于处理手势上的重复操作。
 This class is used to handle repeating actions on a gesture.
 
 shared实例可用于只能同时按下一个按钮来重复执行特定操作的情况。
 The ``shared`` instance can be used if only a single button
 can be pressed to repeat a certain action at any given time.
 */
public class RepeatGestureTimer {

    /// 创建重复手势计时器/Create a repeat gesture timer.
    ///
    /// - Parameters:
    ///   - repeatInterval: 重复时间间隔/The repeat time interval.
    public init(
        repeatInterval: TimeInterval = 0.4
    ) {
        self.repeatInterval = repeatInterval
    }

    deinit { stop() }

    
    /// 共享单例实例/A shared singleton instance.
    @MainActor public static let shared = RepeatGestureTimer()

    /// 重复时间间隔/The repeat time interval.
    public var repeatInterval: TimeInterval


    private var timer: Timer?

    private var startDate: Date?
}

public extension RepeatGestureTimer {

    /// 计时器启动后的流逝时间/The elapsed time since the timer was started.
    var duration: TimeInterval? {
        guard let date = startDate else { return nil }
        return Date().timeIntervalSince(date)
    }

    /// 计时器是否处于激活状态/Whether or not the timer is active.
    var isActive: Bool { timer != nil }

    /// 启动重复手势计时器/Start the repeat gesture timer with a certain action.
    func start(action: @escaping () -> Void) {
        if isActive { return }
        stop()
        startDate = Date()
        timer = Timer.scheduledTimer(
            withTimeInterval: repeatInterval,
            repeats: true) { _ in action() }
    }

    /// 停止重复手势计时器/Stop the repeat gesture timer.
    func stop() {
        timer?.invalidate()
        timer = nil
        startDate = nil
    }
}

extension RepeatGestureTimer {

    func modifyStartDate(to date: Date) {
        startDate = date
    }
}
