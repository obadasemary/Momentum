// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
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
            dependencies: ["Core", "Domain"],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data", "Domain", "Core"],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        )
    ]
)
