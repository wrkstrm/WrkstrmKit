#if canImport(UIKit)
  import UIKit
  import WrkstrmCrossKit

  extension UITableView {
    public func register(nib cells: [UITableViewCell.Type]) {
      for cell in cells {
        register(cell.defaultNib, forCellReuseIdentifier: cell.reuseIdentifier())
      }
    }

    public func register(classes cells: [UITableViewCell.Type]) {
      for cell in cells {
        register(cell.self, forCellReuseIdentifier: cell.reuseIdentifier())
      }
    }

    public func dequeueReusableCell<Cell: TableReusableCell>(
      _ cellClass: Cell.Type,
      for indexPath: IndexPath,
    ) -> Cell {
      // swiftlint:disable:next force_cast
      dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier(), for: indexPath) as! Cell
    }
  }
#endif
