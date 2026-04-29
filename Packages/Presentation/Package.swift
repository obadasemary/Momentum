// ── FILE: Packages/Presentation/Package.swift ──
// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "Presentation", targets: ["Presentation"])
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "Presentation",
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
            name: "PresentationTests",
            dependencies: [
                "Presentation",
                .product(name: "Domain", package: "Domain")
            ],
            swiftSettings: [
                .swiftLanguageVersion(.v6),
                .defaultIsolation(MainActor.self)
            ]
        )
    ]
)
