import Foundation
import UIKit
import UniformTypeIdentifiers
import WrkstrmLog

/// Error types specific to document picking operations
public enum DocumentPickerError: LocalizedError {
  /// No view controller available to present the picker
  case presentationFailed
  /// No document was selected
  case noSelection
  /// Failed to access selected document
  case accessDenied
  /// Failed to create security-scoped bookmark
  case bookmarkCreationFailed

  public var errorDescription: String? {
    switch self {
      case .presentationFailed:
        "Could not present document picker - no view controller available"
      case .noSelection:
        "No document was selected"
      case .accessDenied:
        "Could not access the selected document"
      case .bookmarkCreationFailed:
        "Failed to create security-scoped bookmark for selected document"
    }
  }
}

/// Manages document picking operations with proper delegate lifecycle management.
///
/// `DocumentPickerManager` provides a centralized way to handle document picking operations
/// while ensuring proper memory management of picker delegates. It supports both single
/// and multiple document selection, with options for security-scoped bookmark creation.
///
/// Example usage:
/// ```swift
/// let manager = DocumentPickerManager()
///
/// // Pick a single directory
/// do {
///     let url = try await manager.pickDirectory()
///     // Handle selected directory URL
/// } catch {
///     Log.error("Directory selection failed: \(error)")
/// }
///
/// // Pick multiple files
/// do {
///     let urls = try await manager.pickDocuments(
///         contentTypes: [.image, .pdf],
///         allowsMultiple: true
///     )
///     // Handle selected document URLs
/// } catch {
///     Log.error("Document selection failed: \(error)")
/// }
/// ```
public final class DocumentPickerManager {
  /// Holds active delegate reference to prevent premature deallocation
  private var activeDelegate: DocumentPickerDelegateCompletion?

  /// Creates a new document picker manager instance
  public init() {}

  /// Presents a picker for selecting a directory.
  ///
  /// This method presents a document picker configured for directory selection.
  /// It automatically creates a security-scoped bookmark for the selected directory
  /// and stores it in UserDefaults with the provided key.
  ///
  /// - Parameters:
  ///   - bookmarkKey: The UserDefaults key for storing the security-scoped bookmark.
  ///                  If nil, no bookmark will be created.
  ///   - animated: Whether to animate the picker presentation.
  ///
  /// - Returns: The URL of the selected directory.
  /// - Throws: `DocumentPickerError` if the operation fails.
  @MainActor
  public func pickDirectory(
    bookmarkKey: String? = nil,
    animated: Bool = true
  ) async throws -> URL {
    try await withCheckedThrowingContinuation { continuation in
      let picker: UIDocumentPickerViewController = .init(forOpeningContentTypes: [.folder])
      picker.allowsMultipleSelection = false

      let delegate = DocumentPickerDelegateCompletion { [weak self] urls in
        // Always clear delegate reference on completion
        defer { self?.activeDelegate = nil }

        guard let selectedURL = urls.first else {
          continuation.resume(throwing: DocumentPickerError.noSelection)
          return
        }

        // Create bookmark if requested
        if let key = bookmarkKey {
          do {
            let bookmark = try selectedURL.bookmarkData(
              options: .withSecurityScope,
              includingResourceValuesForKeys: nil,
              relativeTo: nil
            )
            UserDefaults.standard.set(bookmark, forKey: key)
          } catch {
            Log.error("Failed to create bookmark: \(error)")
            continuation.resume(throwing: DocumentPickerError.bookmarkCreationFailed)
            return
          }
        }

        continuation.resume(returning: selectedURL)
      }

      // Store active delegate
      activeDelegate = delegate

      // Retain delegate with picker
      objc_setAssociatedObject(
        picker,
        "delegate",
        delegate,
        .OBJC_ASSOCIATION_RETAIN
      )

      // Present picker
      if let viewController = UIApplication.shared.topViewController() {
        viewController.present(picker, animated: animated)
      } else {
        continuation.resume(throwing: DocumentPickerError.presentationFailed)
      }
    }
  }

  /// Presents a picker for selecting one or more documents.
  ///
  /// This method presents a document picker configured for file selection with
  /// specified content types.
  ///
  /// - Parameters:
  ///   - contentTypes: Array of UTTypes specifying allowed file types
  ///   - allowsMultiple: Whether multiple files can be selected
  ///   - animated: Whether to animate the picker presentation
  ///
  /// - Returns: An array of selected document URLs
  /// - Throws: `DocumentPickerError` if the operation fails
  @MainActor
  public func pickDocuments(
    contentTypes: [UTType],
    allowsMultiple: Bool = false,
    animated: Bool = true
  ) async throws -> [URL] {
    try await withCheckedThrowingContinuation { continuation in
      let picker = UIDocumentPickerViewController(forOpeningContentTypes: contentTypes)
      picker.allowsMultipleSelection = allowsMultiple

      let delegate = DocumentPickerDelegateCompletion { [weak self] urls in
        defer { self?.activeDelegate = nil }

        guard !urls.isEmpty else {
          continuation.resume(throwing: DocumentPickerError.noSelection)
          return
        }

        continuation.resume(returning: urls)
      }

      activeDelegate = delegate

      objc_setAssociatedObject(
        picker,
        "delegate",
        delegate,
        .OBJC_ASSOCIATION_RETAIN
      )

      if let viewController = UIApplication.shared.topViewController() {
        viewController.present(picker, animated: animated)
      } else {
        continuation.resume(throwing: DocumentPickerError.presentationFailed)
      }
    }
  }

  /// Verifies if a security-scoped bookmark exists and is valid
  ///
  /// - Parameter key: The UserDefaults key where the bookmark is stored
  /// - Returns: The resolved URL if the bookmark exists and is valid
  /// - Throws: Error if bookmark is invalid or cannot be resolved
  public func verifyBookmark(forKey key: String) throws -> URL {
    guard let bookmarkData = UserDefaults.standard.data(forKey: key) else {
      throw DocumentPickerError.accessDenied
    }

    var isStale = false
    let url = try URL(
      resolvingBookmarkData: bookmarkData,
      options: .withSecurityScope,
      relativeTo: nil,
      bookmarkDataIsStale: &isStale
    )

    if isStale {
      // Try to recreate bookmark
      let newBookmark = try url.bookmarkData(
        options: .withSecurityScope,
        includingResourceValuesForKeys: nil,
        relativeTo: nil
      )
      UserDefaults.standard.set(newBookmark, forKey: key)
    }

    guard url.startAccessingSecurityScopedResource() else {
      throw DocumentPickerError.accessDenied
    }

    // Remember to call stopAccessingSecurityScopedResource() when done
    return url
  }
}
