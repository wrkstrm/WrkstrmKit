#if canImport(UIKit)
  import UIKit

  extension UIImage {
    // swiftlint:disable:next force_unwrapping
    public static let arrowCircle: UIImage = .init(systemName: "arrow.2.circlepath.circle")!

    // swiftlint:disable:next force_unwrapping
    public static let arrowClockwise: UIImage = .init(systemName: "arrow.clockwise")!

    // swiftlint:disable:next force_unwrapping
    public static let chevronLeft: UIImage = .init(systemName: "chevron.left")!

    // swiftlint:disable:next force_unwrapping
    public static let chevronRight: UIImage = .init(systemName: "chevron.right")!
  }
#endif  // canImport(UIKit)
