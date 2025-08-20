import Foundation
import WrkstrmMain

#if canImport(UIKit)
import UIKit
#endif

/// Provides error throwing capabilities for view controller scenarios
#if canImport(UIKit)
extension UIViewController {
  /// Throws an error with a custom message and pretends to return a value of any type.
  /// This method is particularly useful in guard/optional chaining scenarios where you need
  /// to throw an error when a view controller is not available.
  ///
  /// Example usage:
  /// ```swift
  /// func showAlert() throws {
  ///     let viewController = try navigationController?.topViewController?
  ///         .throw(message: "No view controller to present alert")
  ///     viewController.present(alert, animated: true)
  /// }
  /// ```
  ///
  /// - Note: This method leverages Swift's String conformance from (WrkstrmFoundation) to Error
  ///        protocol for lightweight error handling.
  ///
  /// - Parameter message: A descriptive message explaining why the view controller was not
  ///                    available.
  /// - Returns: Never actually returns since it always throws an error
  /// - Throws: A String error containing the provided message
  public func `throw`<T>(message _: String = "") throws -> T {
    throw StringError("Controller not available: \(T.self)")
  }
}
#endif
