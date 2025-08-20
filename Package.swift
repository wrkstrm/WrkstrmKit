// swift-tools-version:6.1
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
      .package(name: "WrkstrmFoundation", path: "../../universal/WrkstrmFoundation"),
      .package(name: "WrkstrmLog", path: "../../universal/WrkstrmLog"),
      .package(name: "WrkstrmMain", path: "../../universal/WrkstrmMain"),
    ]
  }

  static var remote: [PackageDescription.Package.Dependency] {
    [
      .package(url: "https://github.com/wrkstrm/WrkstrmFoundation.git", from: "2.0.0"),
      .package(url: "https://github.com/wrkstrm/WrkstrmLog.git", from: "2.0.0"),
      .package(url: "https://github.com/wrkstrm/WrkstrmMain.git", from: "2.0.0"),
    ]
  }
}

let package = Package(
  name: "WrkstrmKit",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
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
      dependencies: ["WrkstrmLog"],
      swiftSettings: [.profile],
    ),
    .target(
      name: "WrkstrmCatalystKit",
      dependencies: ["WrkstrmLog", "WrkstrmFoundation", "WrkstrmMain"],
      swiftSettings: [.profile],
    ),
    .target(
      name: "WrkstrmKit",
      dependencies: ["WrkstrmCrossKit", "WrkstrmFoundation", "WrkstrmMain"],
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
      dependencies: ["WrkstrmKit", "WrkstrmCrossKit", "WrkstrmFoundation", "WrkstrmMain"],
      swiftSettings: [.profile],
    ),
  ],
)
