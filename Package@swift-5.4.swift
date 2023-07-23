// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Brick_SwiftUI")

package.platforms = [
    .iOS(.v14),
    .tvOS(.v14),
    .watchOS(.v7),
    .macOS(.v11),
//    .xrOS(.v1)
]

package.products = [
    .library(name: "Brick_SwiftUI", targets: ["Brick_SwiftUI"]),
    .library(name: "Camera", targets: ["Camera"]),
]

package.targets = [
    .target(name: "Brick_SwiftUI", path: "Sources"),
    .target(name: "Camera", dependencies: ["Brick_SwiftUI"], path: "Camera"),
]

package.swiftLanguageVersions = [.v5]
