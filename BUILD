load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")

package(default_visibility = ["//visibility:public"])

swift_library(
    name = "swift-macOS-library",
    module_name = "NSWrkstrmKit",
    srcs = glob(["Source/Swift/Common/**/*.swift",
                 "Source/Swift/macOS/**/*.swift"]),
    deps = ["//HSLuv:swift-macos-library",
            "//WrkstrmFoundation:WSFoundation-swift"],
)

swift_library(
    name = "swift-ios-library",
    module_name = "UIWrkstrmKit",
    srcs = glob(["Source/Swift/Common/**/*.swift",
                 "Source/Swift/iOS/**/*.swift"]),
    deps = ["//HSLuv:swift-ios-library",
            "//WrkstrmFoundation:WSFoundation-swift"],
)

objc_library(
    name = "objc-library",
    module_name = "WrkstrmKitObjc",
    hdrs = glob(["Source/ObjC/*.h"]),
    srcs = glob(["Source/ObjC/*.m"]),
)

swift_library(
    name = "example-sources",
    srcs = glob(["Examples/*.swift"]),
    data = glob(["Examples/Resources/*.storyboard"]),
    deps = [":objc-library",
            "//WrkstrmFoundation:WSFoundation-swift",
            "//WrkstrmKit:swift-ios-library"],
)

ios_application(
    name = "ios-examples",
    bundle_id = "com.wrkstrm.ios.app.wrkstrm-foundation.examples",
    families = ["iphone"],
    minimum_os_version = "10.0",
    infoplists = [":Examples/Info.plist"],
    deps = [":example-sources"],
    provisioning_profile = "wrkstrm.mobileprovision",
)
