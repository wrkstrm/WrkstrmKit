// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "WrkstrmKit",
  platforms: [
    .iOS(.v13),
    .macOS(.v12),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "WrkstrmCrossKit", targets: ["WrkstrmCrossKit"]),
    .library(name: "WrkstrmKit", targets: ["WrkstrmKit"]),
    .library(name: "WrkstrmSwiftUI", targets: ["WrkstrmSwiftUI"]),
    .library(name: "WrkstrmSwiftUIExp", targets: ["WrkstrmSwiftUIExp"]),
  ],
  // Dependencies declare other packages that this package depends on.
  dependencies: [
    .package(name: "WrkstrmFoundation", path: "../WrkstrmFoundation"),
    .package(name: "WrkstrmLog", path: "../WrkstrmLog"),
  ],
  // Targets are the basic building blocks of a package. A target can define a module or a test
  // suite. Targets can depend on other targets in this package, and on products in packages which
  // this package depends on.
  targets: [
    .target(name: "WrkstrmCrossKit", dependencies: ["WrkstrmLog"]),
    .target(
      name: "WrkstrmKit", dependencies: ["WrkstrmCrossKit", "WrkstrmFoundation"]),
    .target(name: "WrkstrmSwiftUI", dependencies: []),
    .target(name: "WrkstrmSwiftUIExp", dependencies: ["WrkstrmSwiftUI", "WrkstrmCrossKit"]),
    .testTarget(name: "WrkstrmKitTests", dependencies: ["WrkstrmKit"]),
  ])
