// swift-tools-version: 5.8

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

let swiftSettings: [SwiftSetting] = [
	.enableExperimentalFeature("StrictConcurrency"),
]

for target in package.targets {
	var settings = target.swiftSettings ?? []
	settings.append(contentsOf: swiftSettings)
	target.swiftSettings = settings
}
