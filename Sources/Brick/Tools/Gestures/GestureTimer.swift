//
//  GestureTimer.swift
//  
//
//  Created by iOS on 2023/6/28.
//
//

import Foundation

/**
 This timer can be used to calculate an elapsed gesture time.
 
 Call ``start()`` when a certain gesture starts then inspect
 ``elapsedTime`` to see how long the gesture has been active.
 */
public class GestureTimer {
    
    public init() {}
    
    private var date: Date?
    
    /// The elapsed time since ``start()`` was called.
    public var elapsedTime: TimeInterval {
        guard let date = date else { return 0 }
        return Date().timeIntervalSince(date)
    }
    
    /// Start the timer.
    public func start() {
        if date != nil { return }
        date = Date()
    }
}
