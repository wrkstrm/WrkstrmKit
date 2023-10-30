// swift-tools-version:5.9
import PackageDescription

let package: Package = .init(
  name: "WrkstrmKit",
  platforms: [
    .iOS(.v15),
    .macOS(.v13),
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
      name: "WrkstrmKit", dependencies: ["WrkstrmCrossKit", "WrkstrmFoundation"],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend",
          "-warn-long-expression-type-checking=50",
        ]),
      ]),
    .target(name: "WrkstrmSwiftUI", dependencies: [], swiftSettings: [
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
