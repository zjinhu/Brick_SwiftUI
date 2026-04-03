//
//  LoadingProgressView.swift
//  Show
//
//  Created by iOS on 2023/5/6.
//

import SwiftUI

/// 步骤视图/Step view
/// 带进度条的Loading视图。/Loading view with progress bar.
struct StepView: View {
    @EnvironmentObject var manager: LoadingManager
    
    var body: some View {
        VStack{
            ProgressView(value: manager.progress)
                .frame(width: 60, height: 60)
                .progressViewStyle(GaugeProgressStyle(strokeColor: manager.accentColor))
                .environment(\.sizeCategory, .small)

            
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

/// 仪表盘进度样式/Gauge progress style
/// 自定义ProgressViewStyle显示进度百分比。/Custom ProgressViewStyle showing progress percentage.
struct GaugeProgressStyle: ProgressViewStyle {
    /// 描边颜色/Stroke color
    var strokeColor = Color.blue
    /// 描边宽度/Stroke width
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
