#if canImport(UIKit)
import UIKit

public struct SceneRoot {
  public let scene: UIWindowScene

  public var window: UIWindow

  public var rootNavController: UINavigationController? {
    window.rootViewController as? UINavigationController
  }

  public var rootViewController: UIViewController {
    // swiftlint:disable:next force_unwrapping
    rootNavController?.viewControllers.first ?? window.rootViewController!
  }

  public init(
    windowScene: UIWindowScene,
    rootViewController: UIViewController = UIViewController()
  ) {
    scene = windowScene
    window = UIWindow(windowScene: windowScene)
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
  }
}
#endif
