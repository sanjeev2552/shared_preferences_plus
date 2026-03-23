// swift-tools-version: 5.7
import PackageDescription

let package = Package(
  name: "shared_preferences_plus_foundation",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15)
  ],
  products: [
    .library(
      name: "shared_preferences_plus_foundation",
      targets: ["shared_preferences_plus_foundation"]
    )
  ],
  dependencies: [
    .package(name: "Flutter", path: "../Flutter")
  ],
  targets: [
    .target(
      name: "shared_preferences_plus_foundation",
      dependencies: [
        .product(name: "Flutter", package: "Flutter", condition: .when(platforms: [.iOS])),
        .product(name: "FlutterMacOS", package: "Flutter", condition: .when(platforms: [.macOS]))
      ],
      resources: [
        .process("Resources/PrivacyInfo.xcprivacy")
      ]
    )
  ]
)
