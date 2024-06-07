// swift-tools-version:5.9.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let package = Package(
    name: "SSAppUpdater",
    platforms: [
        .iOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "SSAppUpdater",
            targets: ["SSAppUpdater"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SSAppUpdater",
            path: "Sources/SSAppUpdater/",
            resources: [
                .copy("Resource/PrivacyInfo.xcprivacy")
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
