#if !canImport(WatchKit)
#if canImport(UIKit)
import UIKit

public typealias View = UIView
#elseif os(OSX)
import Cocoa

public typealias View = NSView
#endif

extension View {

  private enum AssociatedKey {

    static var constraintCache = "wsm_constraintCache"
  }

  typealias ConstraintCache = [NSLayoutConstraint: CGFloat]

  private var constraintCache: ConstraintCache {
    get {
      guard
        let cache = objc_getAssociatedObject(
          self,
          &AssociatedKey.constraintCache) as? ConstraintCache
      else {
        let cache = ConstraintCache()
        objc_setAssociatedObject(
          self,
          &AssociatedKey.constraintCache,
          cache,
          .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return cache
      }
      return cache
    }
    set {
      objc_setAssociatedObject(
        self,
        &AssociatedKey.constraintCache,
        newValue,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  func cache(_ constraint: NSLayoutConstraint) {
    constraintCache[constraint] = constraint.constant
  }

  func reset(_ constraint: NSLayoutConstraint) {
    constraint.constant = constraintCache[constraint, default: 0]
  }

  public func constrainEqual(
    attribute: NSLayoutConstraint.Attribute,
    to: AnyObject,
    multiplier: CGFloat = 1,
    constant: CGFloat = 0
  ) {
    constrainEqual(
      attribute: attribute,
      to: to, attribute,
      multiplier: multiplier,
      constant: constant)
  }

  public func constrainEqual(
    attribute: NSLayoutConstraint.Attribute,
    to: AnyObject,
    _ toAttribute: NSLayoutConstraint.Attribute,
    multiplier: CGFloat = 1,
    constant: CGFloat = 0
  ) {
    NSLayoutConstraint.activate([
      NSLayoutConstraint(
        item: self,
        attribute: attribute,
        relatedBy: .equal,
        toItem: to,
        attribute: toAttribute,
        multiplier: multiplier,
        constant: constant)
    ])
  }

  public func constrainEdges(to view: View) {
    constrainEqual(attribute: .top, to: view, .top)
    constrainEqual(attribute: .leading, to: view, .leading)
    constrainEqual(attribute: .trailing, to: view, .trailing)
    constrainEqual(attribute: .bottom, to: view, .bottom)
  }

  /// If the `view` is nil, we take the superview.
  public func constrainToCenter(in view: View? = nil) {
    guard let container = view ?? superview else { fatalError() }
    centerXAnchor.constrainEqual(anchor: container.centerXAnchor)
    centerYAnchor.constrainEqual(anchor: container.centerYAnchor)
  }

  var centerPoint: CGPoint {
    CGPoint(x: (frame.origin.x + frame.size.width) / 2, y: (frame.origin.y + frame.size.height) / 2)
  }
}

extension NSLayoutAnchor {
  @objc func constrainEqual(anchor: NSLayoutAnchor, constant: CGFloat = 0) {
    constraint(equalTo: anchor, constant: constant).isActive = true
  }
}
#endif  // !canImport(WatchKit)
