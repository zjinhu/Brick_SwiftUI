//
//  LoadingProgressView.swift
//  Show
//
//  Created by iOS on 2023/5/6.
//

import SwiftUI

struct StepView: View {
    @EnvironmentObject var manager: LoadingManager
    
    var body: some View {
        VStack{
            ProgressView(value: manager.progress)
                .frame(width: 60, height: 60)
                .progressViewStyle(GaugeProgressStyle(strokeColor: manager.accentColor))
            
            if let status = manager.text{
                Text("\(status)")
                    .font(manager.textFont)
                    .foregroundColor(manager.textColor)
            }
        }
        .padding(10)
    }
}

struct StepView_Previews: PreviewProvider {
    static var previews: some View {
        StepView()
            .environmentObject(LoadingManager())
    }
}

struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor = Color.blue
    var strokeWidth = 8.0
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        
        return ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
            
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            Text("\(String(format: "%.f", fractionCompleted*100))%")
        }
    }
}
