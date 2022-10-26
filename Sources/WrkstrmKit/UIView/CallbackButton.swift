#if canImport(UIKit)
import UIKit

final class CallbackButton: UIView {

  let onTap: () -> Void

  let button: UIButton

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(title: String, onTap: @escaping () -> Void) {
    self.onTap = onTap
    button = UIButton(type: .system)
    super.init(frame: .zero)
    addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.constrainEdges(to: self)
    button.setTitle(title, for: .normal)
    button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
  }

  @objc func tapped(sender _: AnyObject) {
    onTap()
  }
}
#endif  // canImport(UIKit)
