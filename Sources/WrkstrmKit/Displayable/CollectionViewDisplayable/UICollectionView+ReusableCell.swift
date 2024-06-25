#if canImport(UIKit)
import UIKit
import WrkstrmCrossKit

extension UICollectionView {
  public func register(nib cells: [UICollectionReusableView.Type]) {
    for cell in cells {
      register(cell.defaultNib, forCellWithReuseIdentifier: cell.reuseIdentifier())
    }
  }

  public func register(classes cells: [UICollectionReusableView.Type]) {
    for cell in cells {
      register(cell, forCellWithReuseIdentifier: cell.reuseIdentifier())
    }
  }

  public func dequeueReusableCell<Cell: ReusableCell>(
    _ cellClass: Cell.Type,
    for indexPath: IndexPath
  ) -> Cell {
    dequeueReusableCell(
      withReuseIdentifier: cellClass.reuseIdentifier(),
      for: indexPath) as! Cell  // swiftlint:disable:this force_cast
  }
}
#endif
