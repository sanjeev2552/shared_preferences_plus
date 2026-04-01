// swift-tools-version: 5.7
import PackageDescription

let package = Package(
  name: "shared_preferences_plus_foundation",
  platforms: [
    .iOS("13.0"),
    .macOS("10.15")
  ],
  products: [
    .library(
      name: "shared-preferences-plus-foundation",
      targets: ["shared_preferences_plus_foundation"]
    )
  ],  
  dependencies: [],
  targets: [
    .target(
      name: "shared_preferences_plus_foundation",
      dependencies: [],
      resources: [
        .process("Resources/PrivacyInfo.xcprivacy")
      ]
    )
  ]
)
