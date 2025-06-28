// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SecureAppRequest",
    platforms: [
            .iOS(.v13),     // Minimum iOS version for CryptoKit
            .macOS(.v10_15), // Minimum macOS version for CryptoKit
            .tvOS(.v13),    // Minimum tvOS version for CryptoKit (if applicable)
            .watchOS(.v6)   // Minimum watchOS version for CryptoKit (if applicable)
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SecureAppRequest",
            targets: ["SecureAppRequest"]),
    ],
    dependencies: [
            // No external dependencies needed for CryptoKit
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SecureAppRequest",
        dependencies: []),

    ]
)
