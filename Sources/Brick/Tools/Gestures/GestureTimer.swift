//
//  GestureTimer.swift
//  
//
//  Created by iOS on 2023/6/28.
//
//

import Foundation

/**
 手势计时器/Gesture timer
 可用于计算手势的流逝时间。
 This timer can be used to calculate an elapsed gesture time.
 
 在手势开始时调用start()，然后检查elapsedTime查看手势活跃了多长时间。
 Call ``start()`` when a certain gesture starts then inspect
 ``elapsedTime`` to see how long the gesture has been active.
 */
public class GestureTimer {
    
    /// 初始化手势计时器/Initialize gesture timer
    public init() {}
    
    private var date: Date?
    
    /// 自start()调用以来的流逝时间/The elapsed time since ``start()`` was called.
    public var elapsedTime: TimeInterval {
        guard let date = date else { return 0 }
        return Date().timeIntervalSince(date)
    }
    
    /// 启动计时器/Start the timer.
    public func start() {
        if date != nil { return }
        date = Date()
    }
}
