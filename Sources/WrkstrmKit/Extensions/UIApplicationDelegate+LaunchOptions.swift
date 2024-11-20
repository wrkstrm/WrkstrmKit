/// This file contains type aliases for UIApplicationDelegate-related dictionaries to improve
/// code readability and maintainability. These extensions are only available on platforms that
/// support UIKit and are not WatchKit-based.

#if !canImport(WatchKit)
#if canImport(UIKit)
import UIKit

extension UIApplicationDelegate {
  /// A type alias for the launch options dictionary passed to
  /// `application(_:didFinishLaunchingWithOptions:)`
  ///
  /// This dictionary contains keys indicating which system event triggered the launch of your app
  /// and any relevant data associated with that event. For example, it might indicate that the app
  /// was launched in response to a push notification, a URL scheme, or a file open request.
  ///
  /// Usage:
  /// ```swift
  /// func application(
  ///   _ application: UIApplication,
  ///   didFinishLaunchingWithOptions launchOptions: LaunchOptions?
  /// ) -> Bool {
  ///   // Handle launch options
  ///   if let url = launchOptions?[.url] as? URL {
  ///     // Handle URL-based launch
  ///   }
  ///   return true
  /// }
  /// ```
  public typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]

  /// A type alias for the options dictionary passed to application(_:open:options:)
  ///
  /// This dictionary contains information about how a URL should be opened, including
  /// the source application, annotation data, and whether the URL open request was made
  /// by a universal link.
  ///
  /// Usage:
  /// ```swift
  /// func application(
  ///   _ app: UIApplication,
  ///   open url: URL,
  ///   options: OpenURLOptions
  /// ) -> Bool {
  ///   // Check source application
  ///   if let sourceApp = options[.sourceApplication] as? String {
  ///     // Handle URL from specific source
  ///   }
  ///   return true
  /// }
  /// ```
  public typealias OpenURLOptions = [UIApplication.OpenURLOptionsKey: Any]
}
#endif  // canImport(UIKit)
#endif  // !canImport(WatchKit)
