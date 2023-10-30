#if canImport(UIKit)
import UIKit
import WrkstrmCrossKit

extension UICollectionView {

  public func register(nib cells: [UICollectionReusableView.Type]) {
    cells.forEach {
      self.register($0.defaultNib, forCellWithReuseIdentifier: $0.reuseIdentifier())
    }
  }

  public func register(classes cells: [UICollectionReusableView.Type]) {
    cells.forEach {
      self.register($0, forCellWithReuseIdentifier: $0.reuseIdentifier())
    }
  }

  public func dequeueReusableCell<Cell: ReusableCell>(
    _ cellClass: Cell.Type,
    for indexPath: IndexPath) -> Cell
  {
    dequeueReusableCell(
      withReuseIdentifier: cellClass.reuseIdentifier(),
      for: indexPath) as! Cell  // swiftlint:disable:this force_cast
  }
}
#endif
