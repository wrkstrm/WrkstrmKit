#if canImport(UIKit) || os(OSX)
  #if canImport(UIKit)
    import UIKit

    public typealias View = UIView
  #elseif os(OSX)
    import Cocoa

    public typealias View = NSView
  #endif

  extension View {
    private enum AssociatedKey {
      @MainActor static var constraintCache = "wsm_constraintCache"
    }

    typealias ConstraintCache = [NSLayoutConstraint: CGFloat]

    private var constraintCache: ConstraintCache {
      get {
        guard
          let cache = objc_getAssociatedObject(
            self,
            &AssociatedKey.constraintCache,
          ) as? ConstraintCache
        else {
          let cache: ConstraintCache = .init()
          objc_setAssociatedObject(
            self,
            &AssociatedKey.constraintCache,
            cache,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC,
          )
          return cache
        }
        return cache
      }
      set {
        objc_setAssociatedObject(
          self,
          &AssociatedKey.constraintCache,
          newValue,
          .OBJC_ASSOCIATION_RETAIN_NONATOMIC,
        )
      }
    }

    /// Saves a constraint's current constant so it can be restored later.
    ///
    /// - Parameter constraint: The constraint whose constant should be cached.
    /// - Important: Subsequent calls update the cached constant with the latest value.
    func cache(_ constraint: NSLayoutConstraint) {
      constraintCache[constraint] = constraint.constant
    }

    /// Restores a constraint's constant from the cache.
    ///
    /// - Parameter constraint: The constraint to reset.
    /// - Note: If the constraint has not been cached, its constant defaults to `0`.
    func reset(_ constraint: NSLayoutConstraint) {
      constraint.constant = constraintCache[constraint, default: 0]
    }

    /// Constrains one of the view's attributes equal to the same attribute on `to`.
    ///
    /// Forwards to the overload that accepts distinct attributes.
    ///
    /// - Parameters:
    ///   - attribute: The attribute on the receiver to constrain.
    ///   - to: The item whose attribute is constrained against.
    ///   - multiplier: The multiplier applied to the other attribute. Default `1`.
    ///   - constant: The constant offset to apply. Default `0`.
    public func constrainEqual(
      attribute: NSLayoutConstraint.Attribute,
      to: AnyObject,
      multiplier: CGFloat = 1,
      constant: CGFloat = 0,
    ) {
      constrainEqual(
        attribute: attribute,
        to: to, attribute,
        multiplier: multiplier,
        constant: constant,
      )
    }

    /// Creates and activates an equality constraint between two attributes.
    ///
    /// - Parameters:
    ///   - attribute: The attribute on the receiver to constrain.
    ///   - to: The item whose attribute is constrained against. Both must belong to a compatible
    ///     view hierarchy.
    ///   - toAttribute: The attribute on `to` to constrain to.
    ///   - multiplier: The multiplier applied to the other attribute. Default `1`.
    ///   - constant: The constant offset to apply. Default `0`.
    /// - Important: `translatesAutoresizingMaskIntoConstraints` is not modified.
    public func constrainEqual(
      attribute: NSLayoutConstraint.Attribute,
      to: AnyObject,
      _ toAttribute: NSLayoutConstraint.Attribute,
      multiplier: CGFloat = 1,
      constant: CGFloat = 0,
    ) {
      NSLayoutConstraint.activate([
        NSLayoutConstraint(
          item: self,
          attribute: attribute,
          relatedBy: .equal,
          toItem: to,
          attribute: toAttribute,
          multiplier: multiplier,
          constant: constant,
        )
      ])
    }

    /// Pins all four edges of the view to match those of another view.
    ///
    /// - Parameter view: The view whose edges should be matched.
    /// - Precondition: Both views share a common superview to avoid unsatisfiable constraints.
    public func constrainEdges(to view: View) {
      constrainEqual(attribute: .top, to: view, .top)
      constrainEqual(attribute: .leading, to: view, .leading)
      constrainEqual(attribute: .trailing, to: view, .trailing)
      constrainEqual(attribute: .bottom, to: view, .bottom)
    }

    /// Centers the view within a container.
    ///
    /// - Parameter view: The container to center in. If `view` is nil, the superview is used as the container.
    /// - Precondition: Either `view` or `superview` must be non-`nil`; otherwise a `fatalError` is
    ///   raised.
    /// - Important: Only alignment is affected; the view's size is unchanged.
    public func constrainToCenter(in view: View? = nil) {
      guard let container = view ?? superview else { fatalError() }
      centerXAnchor.constrainEqual(anchor: container.centerXAnchor)
      centerYAnchor.constrainEqual(anchor: container.centerYAnchor)
    }

    /// The geometric center of the view derived from its frame after layout.
    ///
    /// - Returns: A point representing the center based on the current frame.
    /// - Note: Any transform applied to the view is ignored.
    var centerPoint: CGPoint {
      CGPoint(
        x: (frame.origin.x + frame.size.width) / 2, y: (frame.origin.y + frame.size.height) / 2)
    }
  }

  extension NSLayoutAnchor {
    @objc
    func constrainEqual(anchor: NSLayoutAnchor, constant: CGFloat = 0) {
      constraint(equalTo: anchor, constant: constant).isActive = true
    }
  }
#endif  // canImport(UIKit) || os(OSX)
