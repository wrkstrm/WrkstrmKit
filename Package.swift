// swift-tools-version:5.9
import PackageDescription
import Foundation

extension SwiftSetting {
  static let profile: SwiftSetting = .unsafeFlags([
    "-Xfrontend",
    "-warn-long-expression-type-checking=6",
  ])
}

extension ProcessInfo {
  static var useLocalDeps: Bool {
    ProcessInfo.processInfo.environment["SPM_CI_USE_LOCAL_DEPS"] == "true"
  }
}

let wrkstrmDeps: [PackageDescription.Package.Dependency]  =
  ProcessInfo.useLocalDeps ? PackageDescription.Package.Dependency.local : PackageDescription.Package.Dependency.remote
print("---- Wrkstrm Deps ----")
print(wrkstrmDeps.map { $0.kind })
print("---- Wrkstrm Deps ----")

extension PackageDescription.Package.Dependency {
  static var local: [PackageDescription.Package.Dependency] {
    [
      .package(name: "WrkstrmFoundation", path: "../WrkstrmFoundation"),
      .package(name: "WrkstrmLog", path: "../WrkstrmLog"),
      .package(name: "WrkstrmMain", path: "../WrkstrmMain"),
    ]
  }

  static var remote: [PackageDescription.Package.Dependency] {
    [
      .package(url: "https://github.com/wrkstrm/WrkstrmFoundation.git", branch: "main"),
      .package(url: "https://github.com/wrkstrm/WrkstrmLog.git", branch: "main"),
      .package(url: "https://github.com/wrkstrm/WrkstrmMain.git", branch: "main"),
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
    .library(name: "WrkstrmKit", targets: ["WrkstrmKit"]),
    .library(name: "WrkstrmSwiftUI", targets: ["WrkstrmSwiftUI"]),
    .library(name: "WrkstrmSwiftUIExp", targets: ["WrkstrmSwiftUIExp"]),
  ],
  dependencies: wrkstrmDeps,
  targets: [
    .target(
      name: "WrkstrmCrossKit",
      dependencies: ["WrkstrmLog"],
      swiftSettings: [.profile]),
    .target(
      name: "WrkstrmKit",
      dependencies: ["WrkstrmCrossKit", "WrkstrmFoundation", "WrkstrmMain"],
      swiftSettings: [.profile]),
    .target(
      name: "WrkstrmSwiftUI",
      swiftSettings: [.profile]),
    .target(
      name: "WrkstrmSwiftUIExp",
      dependencies: ["WrkstrmSwiftUI", "WrkstrmCrossKit"],
      swiftSettings: [.profile]),
    .testTarget(
      name: "WrkstrmKitTests",
      dependencies: ["WrkstrmKit", "WrkstrmCrossKit", "WrkstrmFoundation", "WrkstrmMain"],
      swiftSettings: [.profile]),
  ])
