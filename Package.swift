// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "WrkstrmKit",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
    .watchOS(.v9),
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
    .package(name: "WrkstrmMain", path: "../WrkstrmMain"),
  ],
  targets: [
    .target(
      name: "WrkstrmCrossKit",
      dependencies: ["WrkstrmLog"],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend",
          "-warn-long-expression-type-checking=50",
        ]),
      ]),
    .target(
      name: "WrkstrmKit",
      dependencies: [
        "WrkstrmCrossKit",
        "WrkstrmFoundation",
        "WrkstrmMain",
      ],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend",
          "-warn-long-expression-type-checking=50",
        ]),
      ]),
    .target(
      name: "WrkstrmSwiftUI",
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend",
          "-warn-long-expression-type-checking=50",
        ]),
      ]),
    .target(
      name: "WrkstrmSwiftUIExp",
      dependencies: ["WrkstrmSwiftUI", "WrkstrmCrossKit"],

      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend",
          "-warn-long-expression-type-checking=50",
        ]),
      ]),
    .testTarget(name: "WrkstrmKitTests", dependencies: ["WrkstrmKit"]),
  ])
