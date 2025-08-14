#if canImport(UIKit) || os(OSX)
  #if canImport(UIKit)
    import UIKit
  #elseif os(OSX)
    import Cocoa
  #endif  // canImport(UIKit)

  @MainActor @objc
  public protocol ReusableCell {
    #if canImport(UIKit)
      static var defaultNib: UINib { get }
    #elseif os(OSX)
      static var defaultNib: NSNib { get }
    #endif  // canImport(UIKit)

    static func reuseIdentifier() -> String

    @objc optional func prepare(for model: Any?, path: IndexPath)
  }

  @objc
  public protocol TableReusableCell: ReusableCell {}

  @objc
  public protocol CollectionReusableCell: ReusableCell {}
#endif  // canImport(UIKit) || os(OSX)
