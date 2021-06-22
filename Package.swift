// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GGGrammar",
    products: [
        .library(
            name: "GGSchema",
            targets: ["GGSchema"]),
        .library(
            name: "GGSources",
            targets: ["GGSources"]),
        .library(
            name: "GGSamples",
            targets: ["GGSamples"]),
    ],
    dependencies: [
        .package(url: "https://github.com/glimpseio/BricBrac.git", .branch("main")),
    ],
    targets: [
        .target(
            name: "GGSchema",
            dependencies: ["BricBrac"]),
        .testTarget(
            name: "GGSchemaTests",
            dependencies: ["GGSchema", .product(name: "Curio", package: "BricBrac")]),
        .target(
            name: "GGSamples",
            resources: [.process("Resources/")]),
        .target(
            name: "GGSources",
            resources: [.process("Resources/")]),
    ]
)

