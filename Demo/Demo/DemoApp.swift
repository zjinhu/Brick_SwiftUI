//
//  DemoApp.swift
//  Demo
//
//  Created by iOS on 2023/6/25.
//

import SwiftUI
import BrickKit
@available(tvOS 16.0, *)
@main
struct DemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            LaunchAppView(title: "BrickKit", backgroundImage: "Image_Launch_2", headImage: "Image_Launch_1"){
                ContentView()
            }
        }
    }
}

let logger = BrickLog()

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        logger.debug("AppDelegate")
        return true
    }
}
