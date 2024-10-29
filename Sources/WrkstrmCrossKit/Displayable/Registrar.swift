#if !canImport(WatchKit)
public struct Registrar {
  public var classes: [ReusableCell.Type]?

  public var nibs: [ReusableCell.Type]?

  public init(classes: [ReusableCell.Type]? = nil, nibs: [ReusableCell.Type]? = nil) {
    self.classes = classes
    self.nibs = nibs
  }

  public static func registrar(
    classes: [ReusableCell.Type]? = nil,
    nibs: [ReusableCell.Type]? = nil
  ) -> Self {
    self.init(classes: classes, nibs: nibs)
  }
}
#endif  // !canImport(WatchKit)
