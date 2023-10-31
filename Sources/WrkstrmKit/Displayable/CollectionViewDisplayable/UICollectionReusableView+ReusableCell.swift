#if canImport(UIKit)
import UIKit
import WrkstrmCrossKit

extension UICollectionReusableView: CollectionReusableCell {
  public static var defaultNib: UINib {
    UINib(nibName: String(describing: self), bundle: Bundle(for: self))
  }

  public static func reuseIdentifier() -> String {
    String(describing: self) + "Identifier"
  }
}
#endif
