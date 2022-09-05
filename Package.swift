// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SwiftyReachability",
    platforms: [.iOS(.v12), .macOS(.v10_14), .watchOS(.v5), .tvOS(.v12)],
    products: [
        .library(
            name: "SwiftyReachability",
            targets: ["SwiftyReachability"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftyReachability",
            dependencies: []),
    ]
)
