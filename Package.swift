// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LayoutAnchorKit",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "LayoutAnchorKit", targets: ["LayoutAnchorKit"]),
    ],
    targets: [
        .target(name: "LayoutAnchorKit", dependencies: [])
    ]
)
