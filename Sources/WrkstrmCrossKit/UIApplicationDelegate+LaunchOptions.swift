#if !canImport(WatchKit)
#if canImport(UIKit)

import UIKit

extension UIApplicationDelegate {

  public typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]

  public typealias OpenURLOptions = [UIApplication.OpenURLOptionsKey: Any]
}
#endif  // !canImport(UIKit)
#endif  // !canImport(WatchKit)
