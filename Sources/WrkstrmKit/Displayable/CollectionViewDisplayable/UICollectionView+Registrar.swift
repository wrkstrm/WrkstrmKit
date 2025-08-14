#if canImport(UIKit)
  import UIKit
  import WrkstrmCrossKit

  extension UICollectionView {
    public func addRegistrar(_ registrar: Registrar) {
      if let classes = registrar.classes as? [UICollectionReusableView.Type] {
        register(classes: classes)
      }
      if let nibs = registrar.nibs as? [UICollectionReusableView.Type] {
        register(nib: nibs)
      }
    }
  }
#endif
