//
//  CountDownTimerView.swift
//  TTShare
//
//  Created by 狄烨 on 2025/3/12.
//

import SwiftUI

public struct CountDownTimerText: View {
    public enum Mode {
        case auto
        case manual
    }
    
    @State private var timeRemaining = 0
    @State private var timeCounting = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let timeUnit: String
    let timeCount: Int
    let titleWhenFinished: String
    let titleWhenIdle: String
    let mode: Mode
    public typealias ResumeAction = () -> Void
    let resumeAction: ResumeAction
    
    public init(timeCount: Int = 59,
                timeUnit: String = "",
                titleWhenIdle: String,
                titleWhenFinished: String,
                mode: Mode = .auto,
                resumeAction: @escaping ResumeAction) {
        self.timeCount = timeCount
        self.timeUnit = timeUnit
        self.titleWhenIdle = titleWhenIdle
        self.titleWhenFinished = titleWhenFinished
        self.mode = mode
        self.resumeAction = resumeAction
        _timeRemaining = State(wrappedValue: timeCount)
        if mode == .auto {
            _timeCounting = State(wrappedValue: true)
        } else {
            _timeCounting = State(wrappedValue: false)
        }
    }
    
    public var body: some View {
        if !timeCounting {
            Text(mode == .manual ? titleWhenIdle : titleWhenFinished)
                .underline()
                .onTapGesture {
                    if mode == .manual {
                        timeRemaining = timeCount
                        timeCounting = true
                        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                        resumeAction()
                    }
                }
        } else {
            Text("\(timeRemaining)\(timeUnit)")
                .underline()
                .onReceive(timer) { _ in
                    if timeRemaining > 1 {
                        timeRemaining -= 1
                    } else {
                        timer.upstream.connect().cancel()
                        timeRemaining = timeCount
                        timeCounting = false
                    }
                }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CountDownTimerText(timeCount: 10, timeUnit: "s", titleWhenIdle: "Get Code", titleWhenFinished: "Send Again", mode: .manual) {
            
        }
        CountDownTimerText(timeCount: 10, timeUnit: "s", titleWhenIdle: "Get Code", titleWhenFinished: "Send Again", mode: .auto) {
            
        }
    }
}
