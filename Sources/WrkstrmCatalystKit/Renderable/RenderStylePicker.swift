#if targetEnvironment(macCatalyst)
import SwiftUI

// MARK: - SwiftUI helper

/// SwiftUI menu to select the current render style.
@MainActor
public struct RenderStylePicker: View {
  @State private var current: RenderStyle = RenderStyleStore.shared.current

  public init(current: RenderStyle = RenderStyleStore.shared.current) {
    self.current = current
  }

  public var body: some View {
    Menu {
      Button(
        "SwiftUI",
        systemImage: "list.bullet"
      ) {
        RenderStyleStore.shared.current = .swiftui
      }
      Button(
        "UIKit",
        systemImage: "square.grid.2x2"
      ) {
        RenderStyleStore.shared.current = .uikit
      }
    } label: {
      Image(systemName: Self.styleIcon(current) ?? "questionmark")
    }
    .onReceive(
      NotificationCenter.default.publisher(for: .renderStyleDidChange)
    ) { notification in
      guard let style = notification.object as? RenderStyle else { return }
      current = style
    }
  }

  @MainActor
  static func styleIcon(_ style: RenderStyle) -> String? {
    switch style {
    case .swiftui: return "list.bullet"
    case .uikit: return "square.grid.2x2"
    }
  }
}
#endif  // targetEnvironment(macCatalyst)
