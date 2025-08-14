#if canImport(SwiftUI) && canImport(UIKit)
  import Combine
  import SwiftUI
  import UIKit

  /// An observable object that publishes updates to a `UIImage` for use in SwiftUI views.
  ///
  /// ```swift
  /// let publisher = UIImagePublisher(UIImage(systemName: "star")!)
  /// Image(uiImage: publisher.uiImage)
  /// ```
  open class UIImagePublisher: ObservableObject {
    /// A cancellable reference to an image loading task.
    public var imageCancellable: AnyCancellable?

    /// The currently published image.
    @Published public var uiImage: UIImage

    /// Creates a publisher with an initial image.
    /// - Parameter uiImage: The starting image to publish.
    /// - Example:
    ///   ```swift
    ///   let publisher = UIImagePublisher(UIImage(named: "Avatar")!)
    ///   ```
    public init(_ uiImage: UIImage) {
      self.uiImage = uiImage
    }
  }
#endif
