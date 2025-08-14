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

    /// Stores the current constant of `constraint` so it can later be restored.
    ///
    /// - Parameter constraint: The constraint whose constant should be saved.
    /// - Note: Calling this repeatedly overwrites any previously cached value for the same constraint.
    /// - Warning: The cache is associated with the view; releasing the view clears the saved constants.
    func cache(_ constraint: NSLayoutConstraint) {
      constraintCache[constraint] = constraint.constant
    }

    /// Restores `constraint`'s constant from the cache.
    ///
    /// - Parameter constraint: The constraint to reset.
    /// - Warning: If the constraint has not been cached, its constant is reset to `0`, which may differ from its original value.
    func reset(_ constraint: NSLayoutConstraint) {
      constraint.constant = constraintCache[constraint, default: 0]
    }

    /// Constrains `attribute` of the view to the same attribute on `to`.
    ///
    /// Forwards to the overload that accepts distinct attributes.
    ///
    /// - Parameters:
    ///   - attribute: The attribute on the receiver to constrain.
    ///   - to: The item whose matching attribute is constrained against. `self` and `to` must share a common superview.
    ///   - multiplier: The multiplier applied to the other attribute. Default `1`.
    ///   - constant: The constant offset to apply. Default `0`.
    /// - Important: `translatesAutoresizingMaskIntoConstraints` is not modified; callers should disable it as needed.
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
    ///   - to: The item whose attribute is constrained against. Both items must belong to a compatible view hierarchy.
    ///   - toAttribute: The attribute on `to` to constrain to.
    ///   - multiplier: The multiplier applied to the other attribute. Default `1`.
    ///   - constant: The constant offset to apply. Default `0`.
    /// - Important: `translatesAutoresizingMaskIntoConstraints` is not modified, and the created constraint is activated immediately.
    /// - Warning: If the attributes are incompatible or the items do not share a superview, Auto Layout will log unsatisfiable constraint warnings at runtime.
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
    /// - Precondition: `self` and `view` must share a common superview; otherwise Auto Layout will complain about unsatisfiable constraints or items not having a common ancestor.
    /// - Important: `translatesAutoresizingMaskIntoConstraints` is not modified and should be disabled prior to calling.
    public func constrainEdges(to view: View) {
      constrainEqual(attribute: .top, to: view, .top)
      constrainEqual(attribute: .leading, to: view, .leading)
      constrainEqual(attribute: .trailing, to: view, .trailing)
      constrainEqual(attribute: .bottom, to: view, .bottom)
    }

    /// Aligns the view's center with that of a container.
    ///
    /// - Parameter view: The container to center in. If `view` is `nil`, the view's `superview` is used.
    /// - Precondition: Either `view` or `superview` must be non-`nil`; otherwise a `fatalError` is raised.
    /// - Note: Only alignment is affected; the view's size is unchanged.
    /// - Important: `translatesAutoresizingMaskIntoConstraints` is not modified.
    public func constrainToCenter(in view: View? = nil) {
      guard let container = view ?? superview else { fatalError() }
      centerXAnchor.constrainEqual(anchor: container.centerXAnchor)
      centerYAnchor.constrainEqual(anchor: container.centerYAnchor)
    }

    /// The geometric center of the view derived from its `frame` after layout.
    ///
    /// - Returns: A point representing the center based on the current `frame`.
    /// - Warning: Any transform applied to the view is ignored, and the value may be outdated if layout has not yet occurred.
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
