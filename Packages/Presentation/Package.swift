// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [.iOS(.v18), .macOS(.v15), .visionOS(.v2)],
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
            dependencies: ["Core", "Domain"],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation", "Domain", "Core"],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        )
    ]
)
