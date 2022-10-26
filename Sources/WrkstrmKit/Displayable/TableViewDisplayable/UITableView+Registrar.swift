#if canImport(UIKit)
import UIKit
import WrkstrmCrossKit

public extension UITableView {

  func addRegistar(_ registrar: Registrar) {
    if let classes = registrar.classes as? [UITableViewCell.Type] {
      register(classes: classes)
    }
    if let nibs = registrar.nibs as? [UITableViewCell.Type] {
      register(nib: nibs)
    }
  }
}
#endif
