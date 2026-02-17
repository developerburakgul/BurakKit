// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BurakKit",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "DynamicColor",
            targets: ["DynamicColor"]
        ),
        .library(
            name: "DependencyContainer",
            targets: ["DependencyContainer"]
        ),
    ],
    targets: [
        .target(
            name: "DynamicColor"
        ),
        .target(
            name: "DependencyContainer"
        ),
        .testTarget(
            name: "DependencyContainerTests",
            dependencies: ["DependencyContainer"]
        ),
        .testTarget(
            name: "DynamicColorTests",
            dependencies: ["DynamicColor"]
        ),
    ]
)
