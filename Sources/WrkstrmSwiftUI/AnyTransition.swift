#if canImport(SwiftUI)
  import SwiftUI

  extension AnyTransition {
    /// A transition that moves a view in from the trailing edge while fading
    /// and scales and fades the view out on removal.
    ///
    /// Use this transition with ``View/transition(_:)`` to animate view
    /// insertion and removal.
    ///
    /// - Returns: A transition combining move, scale, and opacity effects.
    /// ## Example
    ///   ```swift
    ///   Text("Hello").transition(.moveAndFade)
    ///   ```
    public static var moveAndFade: AnyTransition {
      let insertion = Self.move(edge: .trailing)
        .combined(with: .opacity)
      let removal = Self.scale
        .combined(with: .opacity)
      return .asymmetric(insertion: insertion, removal: removal)
    }
  }
#endif
