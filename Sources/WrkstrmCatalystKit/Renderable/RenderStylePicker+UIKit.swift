import Foundation

#if targetEnvironment(macCatalyst)
import UIKit

// MARK: - SwiftUI helper

/// SwiftUI menu to select the current render style.
@MainActor
extension RenderStylePicker {

  // MARK: - RenderStyle button

  @MainActor
  public static func makeRenderStyleButton() -> UIBarButtonItem {
    let store = RenderStyleStore.shared

    // Primary action: quick toggle
    let primary = UIAction(
      title: "Toggle Render Style",
      image: UIImage(systemName: styleIcon(store.current) ?? "list.bullet")
    ) { _ in
      store.toggle()
    }

    // Full menu to pick explicitly (shows on macCatalyst)
    let swiftUI = UIAction(
      title: "SwiftUI",
      image: UIImage(systemName: "list.bullet"),
      state: store.current == .swiftui ? .on : .off
    ) { _ in store.current = .swiftui }

    let uikit = UIAction(
      title: "UIKit",
      image: UIImage(systemName: "square.grid.2x2"),
      state: store.current == .uikit ? .on : .off
    ) { _ in store.current = .uikit }

    let menu = UIMenu(title: "Render Style", children: [swiftUI, uikit])
    let item = UIBarButtonItem(
      systemItem: .organize,
      primaryAction: primary,
      menu: menu
    )

    // Keep the icon in sync when style changes
    NotificationCenter.default.addObserver(
      forName: .renderStyleDidChange,
      object: nil,
      queue: .main
    ) { _ in
      DispatchQueue.main.async {
        item.primaryAction = UIAction(
          title: "Toggle Render Style",
          image: UIImage(systemName: self.styleIcon(store.current) ?? "list.bullet")
        ) { _ in
          store.toggle()
        }
      }
    }
    return item
  }
}
#endif  // targetEnvironment(macCatalyst)
