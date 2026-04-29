// ── FILE: Packages/Domain/Package.swift ──
// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "Domain", targets: ["Domain"])
    ],
    targets: [
        .target(
            name: "Domain",
            swiftSettings: [
                .swiftLanguageVersion(.v6),
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"],
            swiftSettings: [
                .swiftLanguageVersion(.v6),
                .defaultIsolation(MainActor.self)
            ]
        )
    ]
)
