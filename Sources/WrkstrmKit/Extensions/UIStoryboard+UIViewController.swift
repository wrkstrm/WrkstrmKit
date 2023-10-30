import Foundation

#if canImport(UIKit)
import UIKit

// MARK: - UIViewController Convinience Initializers

extension UIStoryboard {
  /// Returns a view controller in a storyboard for an identifier
  ///
  /// - Parameter identifier: The storyboard identifier inside the `UIStoryboard`.
  /// - Returns: A `UIViewController` for the given storyboard identifier.
  public func controller(identifier: String) -> UIViewController {
    instantiateViewController(withIdentifier: identifier)
  }

  /// This function returns an instance of the class type provided.
  ///
  /// - Parameter class: The `UIViewController` class type that will be converted to a storyboard
  /// identifer.
  /// - Returns: An instance of the `UIViewController` class created from the storyboard.
  public func controller<Controller: UIViewController>(class _: Controller.Type) -> Controller {
    // swiftlint:disable:next force_cast
    controller(identifier: String(describing: Controller.self)) as! Controller
  }
}
#endif  // canImport(UIKit)
