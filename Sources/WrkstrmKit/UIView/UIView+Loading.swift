#if canImport(UIKit)
import UIKit

public extension UIView {

  private enum AssociatedKey {

    static var embeddedView = "wsm_embeddedView"
  }

  @IBOutlet var embeddedView: UIView? {
    get {
      objc_getAssociatedObject(self, &AssociatedKey.embeddedView) as? UIView
    }
    set {
      objc_setAssociatedObject(
        self,
        &AssociatedKey.embeddedView,
        newValue,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  // MARK: View Loading

  /// Override this method to specify a nib that is not named similarly to the class name.
  /// This is required for Nested view types in Swift.
  //// Names like Nested.View are translated to simply "View"
  var defaultNib: UINib? { nil }

  /// Calls this method in a commonInit after both init with frame and coder to add the embedded
  /// view.
  func loadEmbeddedView() {
    let nib =
      defaultNib
        ?? UINib(
          nibName: String(describing: type(of: self)),
          bundle: Bundle(for: type(of: self)))
    nib.instantiate(withOwner: self, options: nil)
    if let newView = embeddedView {
      newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      addSubview(newView)
      newView.frame = bounds
      newView.center = boundsCenter
      layoutIfNeeded()
    }
  }
}
#endif
