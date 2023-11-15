#if canImport(CoreGraphics)
import CoreGraphics
import Foundation

// minX       maxX
// |------|
//     mixX     xeO
//     |-----|

extension CGRect {
  public func isIntersecting(with point: CGPoint) -> Bool {
    if point.x >= minX, point.x <= maxX,
       point.y >= minY, point.y <= maxY
    {
      return true
    }
    return false
  }

  public func isIntersecting(with other: CGRect) -> Bool {
    let edges = [
      (other.minX, other.minY),
      (other.minX, other.minY),
      (other.maxX, other.minY),
      (other.maxX, other.maxY),
    ]
    for (x, y) in edges where isIntersecting(with: CGPoint(x: x, y: y)) {
      return true
    }
    return false
  }
}
#endif  // canImport(CoreGraphics)
