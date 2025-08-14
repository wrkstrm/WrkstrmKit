#if canImport(SwiftUI)
  import SwiftUI

  extension AnyTransition {
    /// A transition that moves a view in from the trailing edge while fading,
    /// and scales and fades it out on removal.
    ///
    /// Apply this transition using ``View/transition(_:)``.
    ///
    /// ```swift
    /// Text("Hello").transition(.moveAndFade)
    /// ```
    public static var moveAndFade: AnyTransition {
      let insertion = Self.move(edge: .trailing)
        .combined(with: .opacity)
      let removal = Self.scale
        .combined(with: .opacity)
      return .asymmetric(insertion: insertion, removal: removal)
    }
  }
#endif
