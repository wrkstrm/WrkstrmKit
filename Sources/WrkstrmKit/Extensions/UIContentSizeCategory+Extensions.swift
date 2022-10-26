#if canImport(UIKit)
import UIKit

public extension Notification {

  static let contentSize = Transformer<Void>(
    name: UIContentSizeCategory.didChangeNotification)
}
#endif
