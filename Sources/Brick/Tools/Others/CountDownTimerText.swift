//
//  CountDownTimerView.swift
//  TTShare
//
//  Created by 狄烨 on 2025/3/12.
//

import SwiftUI

/// 倒计时文本视图/Count down timer text view
/// 支持自动和手动两种倒计时模式。/Supports both auto and manual countdown modes.
public struct CountDownTimerText: View {
    /// 倒计时模式/Countdown mode
    public enum Mode {
        /// 自动开始/Auto start
        case auto
        /// 手动开始/Manual start
        case manual
    }
    
    @State private var timeRemaining = 0
    @State private var timeCounting = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /// 时间单位文本/Time unit text
    let timeUnit: String
    /// 倒计时总秒数/Total countdown seconds
    let timeCount: Int
    /// 完成时显示的文本/Text shown when finished
    let titleWhenFinished: String
    /// 空闲时显示的文本/Text shown when idle
    let titleWhenIdle: String
    /// 倒计时模式/Countdown mode
    let mode: Mode
    /// 恢复操作回调/Resume action callback
    public typealias ResumeAction = () -> Bool
    let resumeAction: ResumeAction
    
    /// 初始化倒计时文本/Initialize count down timer text
    /// - Parameters:
    ///   - timeCount: 倒计时总秒数，默认59/Total countdown seconds, default 59
    ///   - timeUnit: 时间单位文本/Time unit text
    ///   - titleWhenIdle: 空闲时显示的文本/Text shown when idle
    ///   - titleWhenFinished: 完成时显示的文本/Text shown when finished
    ///   - mode: 倒计时模式，默认.auto/Countdown mode, default .auto
    ///   - resumeAction: 恢复操作回调/Resume action callback
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
                        let shouldStart = resumeAction()
                        if shouldStart {
                            timeRemaining = timeCount
                            timeCounting = true
                            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                        }
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
            // 返回 true 表示允许开始倒计时
            return true
        }
        CountDownTimerText(timeCount: 10, timeUnit: "s", titleWhenIdle: "Get Code", titleWhenFinished: "Send Again", mode: .auto) {
            return true
        }
    }
}
