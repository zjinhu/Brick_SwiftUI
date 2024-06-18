//
//  GaugeProgressView.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var manager: LoadingManager
    
    var body: some View {
        VStack{
            ProgressView()
#if os(iOS)
                .scaleEffect(2)
#endif
                .frame(width: 50, height: 50)
                .progressViewStyle(CircularProgressViewStyle(tint: manager.accentColor))
            
            if let status = manager.text{
                Text("\(status)")
                    .font(manager.textFont)
                    .foregroundColor(manager.textColor)
            }
        }
        .padding(10)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .environmentObject(LoadingManager())
    }
}
