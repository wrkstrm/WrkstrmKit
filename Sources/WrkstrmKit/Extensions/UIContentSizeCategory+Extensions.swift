#if canImport(UIKit)
import UIKit

extension Notification {

  public static let contentSize = Transformer<Void>(
    name: UIContentSizeCategory.didChangeNotification)
}
#endif
