// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-byte-serializer-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Byte Serializer Primitives",
            targets: ["Byte Serializer Primitives"]
        ),
        .library(
            name: "Byte Serializer Primitives Test Support",
            targets: ["Byte Serializer Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-serializer-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-byte-primitives.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Byte Serializer Primitives",
            dependencies: [
                .product(name: "Serializer Primitive", package: "swift-serializer-primitives"),
                .product(name: "Serializer Primitives", package: "swift-serializer-primitives"),
                .product(name: "Byte Primitives", package: "swift-byte-primitives"),
            ]
        ),
        .target(
            name: "Byte Serializer Primitives Test Support",
            dependencies: [
                "Byte Serializer Primitives",
                .product(name: "Byte Primitives Test Support", package: "swift-byte-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Byte Serializer Primitives Tests",
            dependencies: [
                "Byte Serializer Primitives",
                "Byte Serializer Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
