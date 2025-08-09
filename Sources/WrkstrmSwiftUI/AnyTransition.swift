#if canImport(SwiftUI)
  import SwiftUI

  extension AnyTransition {
    public static var moveAndFade: AnyTransition {
      let insertion = Self.move(edge: .trailing)
        .combined(with: .opacity)
      let removal = Self.scale
        .combined(with: .opacity)
      return .asymmetric(insertion: insertion, removal: removal)
    }
  }
#endif
