// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "BrickKit")

package.platforms = [
    .iOS(.v14),
    .tvOS(.v14),
//    .watchOS(.v8),
    .macOS(.v11),
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

package.swiftLanguageVersions = [.v5]
