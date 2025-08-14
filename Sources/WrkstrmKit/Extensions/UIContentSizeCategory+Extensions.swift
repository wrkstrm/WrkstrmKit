#if canImport(UIKit)
  import UIKit
  import WrkstrmFoundation

  extension Notification {
    public static let contentSize = Transformer<Void>(
      name: UIContentSizeCategory.didChangeNotification)
  }
#endif  // canImport(UIKit)
