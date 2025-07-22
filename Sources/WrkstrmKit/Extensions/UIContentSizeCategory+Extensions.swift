#if canImport(UIKit)
  import UIKit
  import WrkstrmFoundation

  extension Notification {
    public nonisolated(unsafe) static let contentSize = Transformer<Void>(
      name: UIContentSizeCategory.didChangeNotification)
  }
#endif  // canImport(UIKit)
