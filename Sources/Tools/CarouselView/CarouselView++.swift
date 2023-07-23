//
//  View++.swift
//  Example
//
//  Created by iOS on 2023/5/31.
//

import SwiftUI
import Combine

typealias TimePublisher = Publishers.Autoconnect<Timer.TimerPublisher>

extension View {
    
    func onReceive(timer: TimePublisher?,
                   perform action: @escaping (Timer.TimerPublisher.Output) -> Void) -> some View {
        Group {
            if let timer = timer {
                onReceive(timer){ value in
                    action(value)
                }
            } else {
                self
            }
        }
    }
}
