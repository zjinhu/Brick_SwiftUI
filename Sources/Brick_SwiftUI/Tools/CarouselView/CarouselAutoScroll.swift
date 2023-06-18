//
//  AutoScroll.swift
//  Example
//
//  Created by iOS on 2023/5/31.
//

import SwiftUI
public enum CarouselAutoScroll {
    case inactive
    case active(TimeInterval)
}


extension CarouselAutoScroll {

    public static var defaultActive: Self {
        return .active(5)
    }

    var isActive: Bool {
        switch self {
        case .active(let t): return t > 0
        case .inactive : return false
        }
    }

    var interval: TimeInterval {
        switch self {
        case .active(let t): return t
        case .inactive : return 0
        }
    }
}
