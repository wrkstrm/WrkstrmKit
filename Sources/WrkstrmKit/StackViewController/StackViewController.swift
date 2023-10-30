#if canImport(UIKit)
import UIKit
import WrkstrmCrossKit

extension UIStackView {

  convenience init(views: [UIView]) {
    self.init()
    translatesAutoresizingMaskIntoConstraints = false
    axis = .vertical
    distribution = .fill
    spacing = 0
    views.forEach { addArrangedSubview($0) }
  }
}

public protocol GridDelegate: AnyObject {
  func view(for stack: UIStackView, indexPath: IndexPath) -> UIView
}

extension StackViewController {

  public enum ContentElement {

    case label(String)

    case button(String, () -> Void)

    case image(UIImage)
  }

  public enum Style {

    case content([ContentElement], alignment: UIStackView.Alignment)

    case views([UIView], alignment: UIStackView.Alignment)

    case grid(Grid)
  }
}

extension StackViewController.ContentElement {

  public var view: UIView {
    switch self {
      case let .label(text):
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        if #available(iOS 13.0, *) {
          label.textColor = .label
        }
        return label

      case let .button(title, callback):
        return CallbackButton(title: title, onTap: callback)

      case let .image(image):
        let image = UIImageView(image: image)
        image.contentMode = .scaleAspectFit
        return image
    }
  }
}

open class StackViewController: UIViewController {

  public var style: Style

  private(set) var stack: UIStackView

  public weak var gridDelegate: GridDelegate?

  public init(style: Style) {
    self.style = style
    if case let .content(elements, alignment) = style {
      stack = UIStackView(views: elements.map(\.view))
      stack.alignment = alignment
    } else if case let .views(views, alignment) = style {
      stack = UIStackView(views: views)
      stack.alignment = alignment
    } else {
      stack = UIStackView(views: [])
    }
    super.init(nibName: nil, bundle: nil)
    commonInit()
  }

  public required init?(coder aDecoder: NSCoder) {
    style = .views([], alignment: .fill)
    stack = UIStackView(views: [])
    super.init(coder: aDecoder)
  }

  func commonInit() {
    view.addSubview(stack)
    stack.constrainEqual(attribute: .width, to: view)
    if case .grid = style {
      stack.constrainEqual(attribute: .height, to: view)
      stack.distribution = .equalCentering
    }
    stack.constrainToCenter(in: view)
    if #available(iOS 13.0, *) {
      view.backgroundColor = .systemBackground
    } else {
      view.backgroundColor = .groupTableViewBackground
    }
  }

  override open func viewDidLoad() {
    super.viewDidLoad()
    if case let .grid(grid) = style {
      let vertical = UIStackView()
      vertical.axis = .vertical
      vertical.distribution = .fillEqually
      (0..<grid.rows).forEach { rowInt in
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.distribution = .fillEqually
        (0..<grid.columns).forEach { columnInt in
          let path = IndexPath(row: rowInt, section: columnInt)
          if let view = gridDelegate?.view(for: stack, indexPath: path) {
            horizontal.addArrangedSubview(view)
          } else {
            let basicView = view(for: stack, indexPath: path)
            horizontal.addArrangedSubview(basicView)
          }
        }
        vertical.addArrangedSubview(horizontal)
      }
      stack.addArrangedSubview(vertical)
    }
  }

  open func view(for _: UIStackView, indexPath _: IndexPath) -> UIView {
    UIView(frame: .zero)
  }
}
#endif
