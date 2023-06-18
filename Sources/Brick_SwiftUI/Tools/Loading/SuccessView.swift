//
//  SuccessView.swift
//  Show
//
//  Created by iOS on 2023/5/6.
//

import SwiftUI

struct SuccessView: View {
    @EnvironmentObject var manager: LoadingManager
    var body: some View {
        VStack{
            SuccessShape()
                .trim(from: 0.0, to: manager.isActive ? 1.0 : 0.0)
                .stroke(manager.accentColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .animation(.easeInOut(duration: 0.5), value: UUID())
                .frame(width: 50, height: 50)
                .offset(x: -3)
            
            if let status = manager.text{
                Text("\(status)")
                    .font(manager.textFont)
                    .foregroundColor(manager.textColor)
            }
        }
        .padding(10)
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
            .environmentObject(LoadingManager())
    }
}

struct SuccessShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.1, y: rect.width * 0.5))
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.width * 0.8))
        path.addLine(to: CGPoint(x: rect.width * 1.0, y: rect.width * 0.1))
        return path
    }
}
