#if !canImport(WatchKit)
#if canImport(UIKit)

import UIKit
import WrkstrmLog

extension UIApplication {
  /// Get the top view controller from the first window scene.
  /// Checks for the key window and returns the root view controller.
  /// If there is a presented view controller, returns the top view controller.
  /// - Returns: The top view controller.
  public func topViewController() -> UIViewController? {
    guard let windowScene = connectedScenes.first as? UIWindowScene,
      let window = windowScene.windows.first(where: { $0.isKeyWindow }),
      var topController = window.rootViewController
    else {
      Log.kit.error(
        "Could not get top view controller from: \(String(describing: connectedScenes.first))")
      return nil
    }

    while let presentedViewController = topController.presentedViewController {
      topController = presentedViewController
      Log.kit.verbose("Presented Modally: \(topController)")
    }
    return topController
  }
}

#endif  // !canImport(UIKit)
#endif  // !canImport(WatchKit)
