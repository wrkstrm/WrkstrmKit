#if canImport(UIKit)
  import UIKit
  import WrkstrmCrossKit

  extension UITableView {
    public func addRegistar(_ registrar: Registrar) {
      if let classes = registrar.classes as? [UITableViewCell.Type] {
        register(classes: classes)
      }
      if let nibs = registrar.nibs as? [UITableViewCell.Type] {
        register(nib: nibs)
      }
    }
  }
#endif
