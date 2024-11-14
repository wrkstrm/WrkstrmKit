#if canImport(UIKit)
import UIKit

/// A convenience structure that manages the window scene hierarchy for iOS apps.
/// This structure simplifies the setup and management of the app's main window,
/// root view controller, and navigation controller.
///
public struct SceneRoot {
  /// The `UIWindowScene` instance that manages the app's window hierarchy.
  public let scene: UIWindowScene

  /// The main window of the application, initialized with the provided window scene.
  public var window: UIWindow

  /// Optional access to the root navigation controller if one exists.
  /// Returns nil if the root view controller is not a `UINavigationController`.
  public var rootNavController: UINavigationController? {
    window.rootViewController as? UINavigationController
  }

  /// Access to the root view controller of the window.
  /// If a navigation controller exists, returns its first view controller.
  /// Otherwise, returns the window's root view controller.
  public var rootViewController: UIViewController {
    // Force unwrap is safe here as window always has a root view controller after init
    // swiftlint:disable:next force_unwrapping
    rootNavController?.viewControllers.first ?? window.rootViewController!
  }

  /// Initializes a new SceneRoot instance.
  /// - Parameters:
  ///   - windowScene: The UIWindowScene to associate with the window
  ///   - rootViewController: The initial root view controller (defaults to empty
  ///   `UIViewController`)
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
