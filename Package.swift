// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Brick_SwiftUI",
    platforms: [
        .iOS(.v14),
        .tvOS(.v14),
        .watchOS(.v7),
        .macOS(.v11),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Brick_SwiftUI",
            targets: ["Brick_SwiftUI"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Brick_SwiftUI"),
    ],
    swiftLanguageVersions: [.v5]
)
