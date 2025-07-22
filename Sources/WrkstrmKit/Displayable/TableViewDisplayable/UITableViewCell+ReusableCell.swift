#if canImport(UIKit)
  import UIKit
  import WrkstrmCrossKit

  @objc
  public protocol StyleableCell: TableReusableCell {
    static var cellStyle: UITableViewCell.CellStyle { get }

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
  }

  extension UITableViewCell: TableReusableCell {
    @objc
    open class var defaultNib: UINib {
      UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }

    @objc
    open class func reuseIdentifier() -> String {
      String(describing: self) + "Identifier"
    }
  }
#endif
