// ── FILE: Packages/Data/Package.swift ──
// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "Data", targets: ["Data"])
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Domain", package: "Domain")
            ],
            swiftSettings: [
                .swiftLanguageVersion(.v6),
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "DataTests",
            dependencies: [
                "Data",
                .product(name: "Core", package: "Core"),
                .product(name: "Domain", package: "Domain")
            ],
            swiftSettings: [
                .swiftLanguageVersion(.v6),
                .defaultIsolation(MainActor.self)
            ]
        )
    ]
)
