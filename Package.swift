// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GGSpec",
    products: [
        .library(
            name: "GGSpec",
            targets: ["GGSpec"]),
    ],
    dependencies: [
        .package(url: "https://github.com/glimpseio/BricBrac.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "GGSpec",
            dependencies: ["BricBrac"]),
        .testTarget(
            name: "GGSpecTests",
            dependencies: ["GGSpec", .product(name: "Curio", package: "BricBrac")]),
    ]
)
