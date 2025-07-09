// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Brick_SwiftUI")

package.platforms = [
    .iOS(.v15),
    .tvOS(.v15),
//    .watchOS(.v9),
    .macOS(.v12),
//    .visionOS(.v1)
]

package.products = [
    .library(name: "BrickKit", 
             targets: ["BrickKit"]),
]

package.targets = [
    .target(name: "BrickKit",
            path: "Sources/Brick",
            resources: [.process("Resources/PrivacyInfo.xcprivacy")]),
]

//package.swiftLanguageModes = [.v5]
