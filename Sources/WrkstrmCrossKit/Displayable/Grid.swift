#if canImport(CoreGraphics)
  import CoreGraphics

  public struct Grid {
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
