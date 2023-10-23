// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "WrkstrmKit",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "WrkstrmCrossKit", targets: ["WrkstrmCrossKit"]),
    .library(name: "WrkstrmKit", targets: ["WrkstrmKit"]),
    .library(name: "WrkstrmSwiftUI", targets: ["WrkstrmSwiftUI"]),
    .library(name: "WrkstrmSwiftUIExp", targets: ["WrkstrmSwiftUIExp"]),
  ],
  dependencies: [
    .package(name: "WrkstrmFoundation", path: "../WrkstrmFoundation"),
    .package(name: "WrkstrmLog", path: "../WrkstrmLog"),
  ],
  targets: [
    .target(name: "WrkstrmCrossKit", dependencies: ["WrkstrmLog"]),
    .target(
      name: "WrkstrmKit", dependencies: ["WrkstrmCrossKit", "WrkstrmFoundation"]),
    .target(name: "WrkstrmSwiftUI", dependencies: []),
    .target(name: "WrkstrmSwiftUIExp", dependencies: ["WrkstrmSwiftUI", "WrkstrmCrossKit"]),
    .testTarget(name: "WrkstrmKitTests", dependencies: ["WrkstrmKit"]),
  ])
