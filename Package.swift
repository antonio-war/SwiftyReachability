// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "ConnectionManager",
    platforms: [.iOS(.v12), .macOS(.v10_14)],
    products: [
        .library(
            name: "ConnectionManager",
            targets: ["ConnectionManager"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ConnectionManager",
            dependencies: []),
    ]
)
