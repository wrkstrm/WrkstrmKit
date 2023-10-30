#if canImport(UIKit)
import SwiftUI
import UIKit

open class HostingTableViewCell: TableViewCell, StyleableCell {

  public static var cellStyle: UITableViewCell.CellStyle = .subtitle

  public var host = UIHostingController(rootView: AnyView(Color.clear))

  override public required init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }

  open func configure() {
    NSLayoutConstraint.deactivate(host.view.constraints)
    host.view.removeFromSuperview()
    host = UIHostingController(rootView: AnyView(Color.clear))
    contentView.addSubview(host.view)
    host.view.bounds = contentView.bounds
    host.view.clipsToBounds = false
    host.view.preservesSuperviewLayoutMargins = false
    host.view.translatesAutoresizingMaskIntoConstraints = false
  }

  override open func awakeFromNib() {
    super.awakeFromNib()
    prepareForReuse()
  }

  override open func prepareForReuse() {
    super.prepareForReuse()
    NSLayoutConstraint.deactivate(host.view.constraints)
    host.view.transform = CGAffineTransform.identity
  }

  open func prepareForDisplay(_ view: some SwiftUI.View) {
    host.rootView = AnyView(view)
    host.view.layoutSubviews()
    contentView.bounds = host.view.bounds
    let height = host.view.intrinsicContentSize.height
    let heightAnchor = contentView.heightAnchor.constraint(equalToConstant: height)
    heightAnchor.priority = UILayoutPriority(rawValue: 850)
    heightAnchor.isActive = true
    host.view.constrainEdges(to: contentView)
    updateConstraintsIfNeeded()
  }
}
#endif  // canImport(UIKit)
