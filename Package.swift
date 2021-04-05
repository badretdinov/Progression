// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Progression",
    platforms: [.iOS(.v10), .macOS(.v10_12), .watchOS(.v3), .tvOS(.v10)],
    products: [
        .library(
            name: "Progression",
            targets: ["Progression"]),
    ],
    dependencies: [
        .package(url: "https://github.com/marmelroy/Zip.git", .exact("2.1.1"))
    ],
    targets: [
        .target(
            name: "Progression",
            dependencies: [],
            path: "Progression"),
        .testTarget(
            name: "ProgressionTests",
            dependencies: ["Progression", "Zip"],
            path: "ProgressionTests",
            resources: [
                .process("TestData/Resources")
            ])
    ]
)
