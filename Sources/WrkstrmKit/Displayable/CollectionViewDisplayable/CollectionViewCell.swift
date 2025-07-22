#if canImport(UIKit)
  import UIKit

  open class CollectionViewCell: UICollectionViewCell {
    var model: Any?

    weak var delegate: UIViewController?
  }
#endif
