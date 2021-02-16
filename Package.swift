// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ContainedDocument",
    platforms: [.macOS("10.11")],
    products: [
        .library(name: "ContainedDocument", targets: ["ContainedDocument"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "ContainedDocument", dependencies: [], path: "ContainedDocument/"),
        .testTarget(name: "ContainedDocumentTests", dependencies: ["ContainedDocument"], path: "ContainedDocumentTests/"),
    ]
)
