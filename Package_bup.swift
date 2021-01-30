// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "TFUI",
  platforms: [
    .iOS(.v13),         //.v8 - .v13
    .macOS(.v10_15),    //.v10_10 - .v10_15
  ],
  products: [
    .library(name: "TFUI", targets: ["TFUI"])
  ],
  dependencies: [
    .package(url: "https://github.com/nakiostudio/EasyPeasy.git", from: "1.10.0")
  ],
  targets: [
    .target(name: "TFUI", dependencies: ["EasyPeasy"])
  ]
)
