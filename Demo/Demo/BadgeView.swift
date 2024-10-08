//
//  Badge.swift
//  Example
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI
import BrickKit
struct BadgeView: View {
    @State private var alert = false
    //    @EnvironmentObject var tabVisibility: TabbarVisibility
    
    struct Badge: View {
        var body: some View {
            Circle()
                .fill(Color.blue)
                .frame(width: 40, height: 40)
        }
    }
    
    
    var body: some View {
        VStack(spacing: 44) {
            
            //            Button {
            //                withAnimation(.easeInOut(duration: 0.25)) {
            //                    tabVisibility.visibility.toggle()
            //                }
            //            } label: {
            //                Text("Hide/Show TabBar")
            //            }
            
            Rectangle()
                .ss.badge(alignment: .topLeading) {
                    Badge()
                }
                .ss.badge(alignment: .topTrailing) {
                    Badge()
                }
                .ss.badge(alignment: .bottomLeading) {
                    Badge()
                }
                .ss.badge(alignment: .bottomTrailing) {
                    Badge()
                }
                .shadow(color: .black, radius: 50, x: 0, y: 0)
                .frame(width: 100, height: 100)
            
            HStack {
                Circle()
                    .ss.badge(alignment: .topLeading) {
                        Badge()
                    }
                
                Circle()
                    .ss.badge(alignment: .topTrailing) {
                        Badge()
                    }
                
                Circle()
                    .ss.badge(alignment: .bottomLeading) {
                        Badge()
                    }
                
                Circle()
                    .ss.badge(alignment: .bottomTrailing) {
                        Badge()
                    }
            }
            .padding(.horizontal)
        }
        //        .onAppear{
        //            withAnimation{
        //                tabVisibility.visibility = .hidden
        //            }
        //        }
        //        .onDisappear{
        //            withAnimation{
        //                tabVisibility.visibility = .visible
        //            }
        //        }
#if os(iOS)
        .ss.tabBar(.hidden)
#endif
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView()
    }
}

struct PausableRotation: GeometryEffect {

    @Binding var currentAngle: CGFloat
    private var currentAngleValue: CGFloat = 0.0

    var animatableData: CGFloat {
        get { currentAngleValue }
        set { currentAngleValue = newValue }
    }
    
    init(desiredAngle: CGFloat, currentAngle: Binding<CGFloat>) {
        self.currentAngleValue = desiredAngle
        self._currentAngle = currentAngle
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        
        DispatchQueue.main.async {
            self.currentAngle = currentAngleValue
        }

        let xOffset = size.width / 2
        let yOffset = size.height / 2
        let transform = CGAffineTransform(translationX: xOffset, y: yOffset)
            .rotated(by: currentAngleValue)
            .translatedBy(x: -xOffset, y: -yOffset)
        return ProjectionTransform(transform)
    }
}

struct RotatView: View {
    @State private var isRotating: Bool = false
    
    @State private var desiredAngle: CGFloat = 0.0
    
    @State private var currentAngle: CGFloat = 0.0
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 1.8)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        Button(action: {
            self.isRotating.toggle()
            // normalize the angle so that we're not in the tens or hundreds of radians
            let startAngle = currentAngle.truncatingRemainder(dividingBy: CGFloat.pi * 2)
            // if rotating, the final value should be one full circle furter
            // if not rotating, the final value is just the current value
            let angleDelta = isRotating ? CGFloat.pi * 2 : 0.0
            withAnimation(isRotating ? foreverAnimation : .linear(duration: 0)) {
                self.desiredAngle = startAngle + angleDelta
            }
        }, label: {
            Text("🐰")
                .font(.largeTitle)
                .modifier(PausableRotation(desiredAngle: desiredAngle, currentAngle: $currentAngle))
        })
    }
}

#Preview {
    RotatView()
}
