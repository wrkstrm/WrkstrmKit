#if canImport(UIKit)
import CoreFoundation
import CoreGraphics
import UIKit

extension UIImage {
  public static func color(_ color: UIColor, size: CGSize) -> UIImage {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    // swiftlint:disable:next force_unwrapping
    return image!
  }
}
#endif  // canImport(UIKit)
