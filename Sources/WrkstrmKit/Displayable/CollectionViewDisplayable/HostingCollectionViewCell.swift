#if canImport(SwiftUI) && canImport(UIKit)
  import SwiftUI
  import UIKit

  @MainActor open class HostingCollectionViewCell: CollectionViewCell {
    public var host: UIHostingController = .init(rootView: AnyView(Color.clear))

    override public init(frame: CGRect) {
      super.init(frame: frame)
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
      Task { @MainActor in
        self.prepareForReuse()
      }
    }

    override open func prepareForReuse() {
      super.prepareForReuse()
      NSLayoutConstraint.deactivate(host.view.constraints)
      host.view.transform = CGAffineTransform.identity
    }

    open func prepareForDisplay(_ view: some SwiftUI.View) {
      host.rootView = AnyView(view)
      host.view.layoutSubviews()
      let height = host.view.intrinsicContentSize.height
      let heightAnchor = contentView.heightAnchor.constraint(equalToConstant: height)
      heightAnchor.priority = UILayoutPriority(rawValue: 725)
      heightAnchor.isActive = true
      contentView.bounds = host.view.bounds
      host.view.constrainEdges(to: contentView)
      updateConstraintsIfNeeded()
    }
  }
#endif
