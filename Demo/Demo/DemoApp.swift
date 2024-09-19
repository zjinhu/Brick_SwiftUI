//
//  DemoApp.swift
//  Demo
//
//  Created by iOS on 2023/6/25.
//

import SwiftUI

@available(tvOS 16.0, *)
@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchAppView(title: "BrickKit", backgroundImage: "Image_Launch_2", headImage: "Image_Launch_1"){
                ContentView()
            }
        }
    }
}
