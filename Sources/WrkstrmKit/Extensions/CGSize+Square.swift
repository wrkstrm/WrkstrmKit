#if canImport(CoreGraphics)
import CoreGraphics

extension CGSize {

  static func square(size: some BinaryFloatingPoint) -> CGSize { CGSize(square: size) }

  init(square size: some BinaryFloatingPoint) {
    self.init()
    width = CGFloat(size)
    height = CGFloat(size)
  }
}
#endif  // canImport(CoreGraphics)
