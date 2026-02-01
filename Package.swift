// swift-tools-version:6.2
import Foundation
import PackageDescription

extension SwiftSetting {
  static let profile: SwiftSetting = .unsafeFlags([
    "-Xfrontend",
    "-warn-long-expression-type-checking=10",
  ])
}

extension ProcessInfo {
  static var useLocalDeps: Bool {
    ProcessInfo.processInfo.environment["SPM_USE_LOCAL_DEPS"] == "true"
  }
}

let wrkstrmDeps: [PackageDescription.Package.Dependency] =
  ProcessInfo.useLocalDeps
  ? PackageDescription.Package.Dependency.local
  : PackageDescription
    .Package.Dependency.remote
print("---- Wrkstrm Deps ----")
print(wrkstrmDeps.map(\.kind))
print("---- Wrkstrm Deps ----")

extension PackageDescription.Package.Dependency {
  static var local: [PackageDescription.Package.Dependency] {
    [
      .package(name: "wrkstrm-foundation", path: "../../universal/domain/system/wrkstrm-foundation"),
      .package(name: "common-log", path: "../../universal/domain/system/common-log"),
      .package(name: "wrkstrm-main", path: "../../universal/domain/system/wrkstrm-main"),
    ]
  }

  static var remote: [PackageDescription.Package.Dependency] {
    [
      .package(name: "wrkstrm-foundation", path: "../../universal/domain/system/wrkstrm-foundation"),
      .package(url: "https://github.com/wrkstrm/common-log.git", from: "3.0.0"),
      .package(name: "wrkstrm-main", path: "../../universal/domain/system/wrkstrm-main"),
    ]
  }
}

let package = Package(
  name: "WrkstrmKit",
  platforms: [
    .iOS(.v16),
    .macOS(.v15),
    .tvOS(.v16),
    .watchOS(.v9),
  ],
  products: [
    .library(name: "WrkstrmCrossKit", targets: ["WrkstrmCrossKit"]),
    .library(name: "WrkstrmCatalystKit", targets: ["WrkstrmCatalystKit"]),
    .library(name: "WrkstrmKit", targets: ["WrkstrmKit"]),
    .library(name: "WrkstrmSwiftUI", targets: ["WrkstrmSwiftUI"]),
    .library(name: "WrkstrmSwiftUIExp", targets: ["WrkstrmSwiftUIExp"]),
  ],
  dependencies: wrkstrmDeps,
  targets: [
    .target(
      name: "WrkstrmCrossKit",
      dependencies: [
        .product(name: "CommonLog", package: "common-log")
      ],
      swiftSettings: [.profile],
    ),
    .target(
      name: "WrkstrmCatalystKit",
      dependencies: [
        .product(name: "CommonLog", package: "common-log"),
        .product(name: "WrkstrmFoundation", package: "wrkstrm-foundation"),
        .product(name: "WrkstrmMain", package: "wrkstrm-main")
      ],
      swiftSettings: [.profile],
    ),
    .target(
      name: "WrkstrmKit",
      dependencies: [
        "WrkstrmCrossKit",
        .product(name: "WrkstrmFoundation", package: "wrkstrm-foundation"),
        .product(name: "WrkstrmMain", package: "wrkstrm-main")
      ],
      swiftSettings: [.profile],
    ),
    .target(
      name: "WrkstrmSwiftUI",
      swiftSettings: [.profile],
    ),
    .target(
      name: "WrkstrmSwiftUIExp",
      dependencies: ["WrkstrmSwiftUI", "WrkstrmCrossKit"],
      swiftSettings: [.profile],
    ),
    .testTarget(
      name: "WrkstrmKitTests",
      dependencies: [
        "WrkstrmKit",
        "WrkstrmCrossKit",
        .product(name: "WrkstrmFoundation", package: "wrkstrm-foundation"),
        .product(name: "WrkstrmMain", package: "wrkstrm-main")
      ],
      swiftSettings: [.profile],
    ),
  ],
)

