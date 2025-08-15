#if canImport(UIKit)
import UIKit

/// A delegate handler for UIDocumentPickerViewController that simplifies document selection
/// results.
///
/// `DocumentPickerDelegate` manages the delegate callbacks from a document picker and converts them
/// into a single completion handler, making it easier to handle file/directory selection results.
///
/// Example usage:
/// ```swift
/// func selectDirectory() {
///     let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
///     let delegate = DocumentPickerDelegate { urls in
///         guard let selectedURL = urls.first else { return }
///         // Handle the selected directory URL
///     }
///
///     // Keep delegate alive for the duration of the picker
///     objc_setAssociatedObject(documentPicker, "delegate", delegate, .OBJC_ASSOCIATION_RETAIN)
///
///     present(documentPicker, animated: true)
/// }
/// ```
///
/// - Important: You must maintain a strong reference to this delegate while the picker is active.
///   A common pattern is to use `objc_setAssociatedObject` to tie the delegate's lifecycle to the
///   picker.
///
/// - Note: The delegate automatically handles both successful selection and cancellation scenarios,
///   calling the completion handler with either the selected URLs or an empty array.
public final class DocumentPickerDelegateCompletion: NSObject, UIDocumentPickerDelegate {
  /// A closure that receives the array of selected document URLs.
  /// - Parameter urls: An array of URLs representing the selected documents.
  ///                  If the picker was cancelled, this array will be empty.
  private let completion: ([URL]) -> Void

  /// Creates a new document picker delegate with a completion handler.
  ///
  /// - Parameter completion: A closure to be called when document selection completes or is
  ///                       cancelled. The closure receives an array of URLs for the selected
  ///                       documents. If the picker is cancelled, it receives an empty array.
  ///
  /// - Note: The completion handler is retained for the lifetime of the delegate.
  public init(completion: @escaping ([URL]) -> Void) {
    self.completion = completion
  }

  /// Handles successful document selection.
  ///
  /// Called by the system when the user successfully selects one or more documents.
  /// This method forwards the selected URLs to the completion handler.
  ///
  /// - Parameters:
  ///   - controller: The document picker view controller.
  ///   - urls: An array of URLs representing the selected documents.
  public func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    completion(urls)
  }

  /// Handles picker cancellation.
  ///
  /// Called by the system when the user cancels the document picker.
  /// This method calls the completion handler with an empty array.
  ///
  /// - Parameter controller: The document picker view controller.
  public func documentPickerWasCancelled(_: UIDocumentPickerViewController) {
    completion([])
  }
}
#endif  // canImport(UIKit)
