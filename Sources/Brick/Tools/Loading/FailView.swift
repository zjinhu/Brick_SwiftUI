//
//  FailedView.swift
//  Show
//
//  Created by iOS on 2023/5/6.
//

import SwiftUI

struct FailView: View {
    @EnvironmentObject var manager: LoadingManager
    @State private var isDrawn = false
    var body: some View {
        VStack{
            XShape()
                .trim(from: 0.0, to: manager.isActive ? 1.0 : 0.0)
                .stroke(manager.accentColor, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .animation(.easeInOut(duration: 0.5), value: UUID())
                .frame(width: 50, height: 50)

            
            if let status = manager.text{
                Text("\(status)")
                    .font(manager.textFont)
                    .foregroundColor(manager.textColor)
            }
        }
        .padding(10)
    }
}

struct FailedView_Previews: PreviewProvider {
    static var previews: some View {
        FailView()
            .environmentObject(LoadingManager())
    }
}

struct XShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.15, y: rect.width * 0.15))
        path.addLine(to: CGPoint(x: rect.width * 0.85, y: rect.width * 0.85))
        path.move(to: CGPoint(x: rect.width * 0.15, y: rect.width * 0.85))
        path.addLine(to: CGPoint(x: rect.width * 0.85, y: rect.width * 0.15))
        return path
    }
}
