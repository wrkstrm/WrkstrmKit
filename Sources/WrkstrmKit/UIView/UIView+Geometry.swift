#if canImport(UIKit)
import UIKit

@objc public extension UIView {

  /// Returns the center of the bounds.
  /// Helpful when trying to center a subview insdide another subview.
  var boundsCenter: CGPoint {
    CGPoint(x: bounds.midX, y: bounds.midY)
  }

  func round(corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(
      roundedRect: bounds,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
}
#endif
