// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// optimizing the GGSchema reduces the size of GGSchema.o from ~46M -> 
let optimize = [SwiftSetting.unsafeFlags(["-cross-module-optimization", "-Osize"])]

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
            dependencies: ["BricBrac"],
            swiftSettings: optimize),
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

