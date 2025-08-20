#if canImport(UIKit) || canImport(Cocoa) || targetEnvironment(macCatalyst)
#if canImport(UIKit)
import UIKit
#elseif canImport(Cocoa)
import Cocoa
#endif  // canImport(Cocoa)

@MainActor @objc
public protocol ReusableCell {
  #if canImport(UIKit)
  static var defaultNib: UINib { get }
  #elseif canImport(Cocoa)
  static var defaultNib: NSNib { get }
  #endif  // canImport(Cocoa)

  static func reuseIdentifier() -> String

  @objc optional func prepare(for model: Any?, path: IndexPath)
}

@objc
public protocol TableReusableCell: ReusableCell {}

@objc
public protocol CollectionReusableCell: ReusableCell {}
#endif  // canImport(UIKit) || canImport(Cocoa) || targetEnvironment(macCatalyst)
