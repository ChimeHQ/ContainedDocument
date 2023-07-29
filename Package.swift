// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "ContainedDocument",
	platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "ContainedDocument", targets: ["ContainedDocument"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "ContainedDocument"),
        .testTarget(name: "ContainedDocumentTests", dependencies: ["ContainedDocument"]),
    ]
)
