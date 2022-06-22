#if canImport(UIKit)
import UIKit

public protocol Root {

  var window: UIWindow { get }
}

extension Root {

  public var rootNavController: UINavigationController? {
    window.rootViewController as? UINavigationController
  }

  public var rootViewController: UIViewController {
    // swiftlint:disable:next force_unwrapping
    rootNavController?.viewControllers.first ?? window.rootViewController!
  }
}

public class AppRoot: Root {

  public var window: UIWindow

  public init(frame: CGRect, rootViewController: UIViewController = UIViewController()) {
    window = UIWindow(frame: frame)
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
  }
}

@available(iOS 13.0, *)
public final class SceneRoot: Root {

  public let scene: UIWindowScene

  public var window: UIWindow

  public init(
    windowScene: UIWindowScene,
    rootViewController: UIViewController = UIViewController()) {
    scene = windowScene
    window = UIWindow(windowScene: windowScene)
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
  }
}

#endif
