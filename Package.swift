// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Progression",
    platforms: [.iOS(.v11), .macOS(.v10_12), .watchOS(.v3)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Progression",
            targets: ["Progression"]),
    ],
    dependencies: [
        .package(url: "https://github.com/marmelroy/Zip.git", .exact("2.1.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Progression",
            dependencies: [],
            path: "Progression"),
//        .testTarget(
//            name: "ProgressionTests",
//            dependencies: ["Progression", "Zip"],
//            path: "ProgressionTests",
//            resources: [
//                    // Copy Tests/ExampleTests/Resources directories as-is.
//                    // Use to retain directory structure.
//                    // Will be at top level in bundle.
//                .process("TestData/Resources/DBFiles"),
//                .copy("TestData/Resources/ZippedDBs"),
//            ]),
    ]
)
