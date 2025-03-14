//
//  CountDownTimerView.swift
//  TTShare
//
//  Created by 狄烨 on 2025/3/12.
//

import SwiftUI

public struct CountDownTimerText: View {
    @State private var timeRemaining = 0

    @State private var timeCounting = true
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    let timeUnit: String
    let timeCount: Int
    let text: String
    public typealias ResumeAction = () -> Void
    let resumeAction: ResumeAction
    public init(text: String,
                timeCount: Int = 59,
                timeUnit: String = "",
                resumeAction: @escaping ResumeAction) {
        self.text = text
        self.timeCount = timeCount
        self.timeUnit = timeUnit
        self.resumeAction = resumeAction
        _timeRemaining = State(wrappedValue: timeCount)
    }
    
    public var body: some View {
        if !timeCounting{
            Text(text)
                .underline()
                .onTapGesture {
                    timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    timeCounting.toggle()
                    resumeAction()
                }
        }else{
            Text("\(timeRemaining)\(timeUnit)")
                .underline()
                .onReceive(timer) { time in
                    if timeRemaining > 1 {
                        timeRemaining -= 1
                    }else{
                        timer.upstream.connect().cancel()
                        timeRemaining = 59
                        timeCounting.toggle()
                    }
                }
        }
    }
}

#Preview {
    CountDownTimerText(text: "Send Again", timeCount: 10, timeUnit: "s"){
        
    }
}
