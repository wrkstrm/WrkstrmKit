#if canImport(CoreGraphics)
import CoreGraphics

extension CGSize {

  static func square<Value: BinaryFloatingPoint>(size: Value) -> CGSize { CGSize(square: size) }

  init<Value: BinaryFloatingPoint>(square size: Value) {
    self.init()
    width = CGFloat(size)
    height = CGFloat(size)
  }
}
#endif  //canImport(CoreGraphics)
