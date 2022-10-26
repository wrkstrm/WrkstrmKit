#if !canImport(WatchKit)
#if canImport(UIKit)

import UIKit

public extension UIApplicationDelegate {

  typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]

  typealias OpenURLOptions = [UIApplication.OpenURLOptionsKey: Any]
}
#endif  // !canImport(UIKit)
#endif  // !canImport(WatchKit)
