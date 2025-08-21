#if canImport(CoreGraphics)
import CoreGraphics

/// A lightweight model describing a two-dimensional layout used to calculate
/// item sizes for grid-based interfaces. This type is unrelated to SwiftUI's
/// `Grid` view; it simply specifies the number of rows and columns available
/// for placing content within a given frame.
public struct LayoutGrid {
  public let rows: Int

  public let columns: Int

  public init(rows: Int, columns: Int) {
    self.rows = rows
    self.columns = columns
  }

  public func itemSize(for frame: CGSize) -> CGSize {
    CGSize(width: frame.width / CGFloat(rows), height: frame.height / CGFloat(columns))
  }
}
#endif  // canImport(CoreGraphics)
