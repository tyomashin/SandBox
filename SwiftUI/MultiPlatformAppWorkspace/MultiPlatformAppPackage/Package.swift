// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MultiPlatformAppPackage",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "Entities",targets: ["Entities"]),
        .library(name: "Views", targets: ["Views"]),
        .library(name: "ViewModels", targets: ["ViewModels"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "UseCase", targets: ["UseCase"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "Entities", dependencies: []),
        .target(name: "Views", dependencies: ["Entities", "ViewModels"]),
        .target(name: "ViewModels", dependencies: ["UseCase", "Entities"]),
        .target(name: "AppFeature", dependencies: []),
        .target(name: "UseCase", dependencies: ["Entities"]),
        .testTarget(name: "PackageTests", dependencies: ["Entities"]),
    ]
)
