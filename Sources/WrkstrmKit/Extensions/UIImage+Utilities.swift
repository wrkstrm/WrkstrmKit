#if canImport(UIKit)
import CoreFoundation
import CoreGraphics
import UIKit

extension UIImage {
  public static func color(_ color: UIColor, size: CGSize) -> UIImage {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image ?? UIImage()
  }
}
#endif  // canImport(UIKit)
