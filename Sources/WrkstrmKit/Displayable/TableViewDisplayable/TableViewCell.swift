#if canImport(UIKit)
  import UIKit

  open class TableViewCell: UITableViewCell {
    public var model: Any?

    public weak var tableView: UITableView?

    public weak var delegate: UIViewController?
  }
#endif
