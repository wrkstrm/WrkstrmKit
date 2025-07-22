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
    @MainActor public var view: UIView {
      switch self {
      case .label(let text):
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.text = text
        if #available(iOS 13.0, *) {
          label.textColor = .label
        }
        return label

      case .button(let title, let callback):
        return CallbackButton(title: title, onTap: callback)

      case .image(let image):
        let image: UIImageView = .init(image: image)
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
      if case .content(let elements, let alignment) = style {
        stack = UIStackView(views: elements.map(\.view))
        stack.alignment = alignment
      } else if case .views(let views, let alignment) = style {
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
      if case .grid(let grid) = style {
        let vertical: UIStackView = .init()
        vertical.axis = .vertical
        vertical.distribution = .fillEqually
        for rowInt in 0..<grid.rows {
          let horizontal: UIStackView = .init()
          horizontal.axis = .horizontal
          horizontal.distribution = .fillEqually
          for columnInt in 0..<grid.columns {
            let path: IndexPath = .init(row: rowInt, section: columnInt)
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
