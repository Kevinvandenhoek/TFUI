// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "TFUI",
  platforms: [
    .iOS(.v13),         //.v8 - .v13
    .macOS(.v10_15),    //.v10_10 - .v10_15
    .tvOS(.v13),        //.v9 - .v13
    .watchOS(.v6),      //.v2 - .v6
  ],
  dependencies: [
    .package(url: "https://github.com/nakiostudio/EasyPeasy.git", from: "1.10.0")
  ]
)
