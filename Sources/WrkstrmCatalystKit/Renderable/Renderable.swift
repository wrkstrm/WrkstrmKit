#if targetEnvironment(macCatalyst)
import SwiftUI

extension Notification.Name {
  public static let renderStyleDidChange = Notification.Name("RenderStyleStore.didChange")
}

public enum RenderStyle: String { case swiftui, uikit }

public final class RenderStyleStore {
  @MainActor public static let shared = RenderStyleStore()

  private let key = "RenderStyle"
  private init() {}

  public var current: RenderStyle {
    get {
      RenderStyle(rawValue: UserDefaults.standard.string(forKey: key) ?? "")
        ?? .swiftui
    }
    set {
      guard newValue != current else { return }
      UserDefaults.standard.set(newValue.rawValue, forKey: key)
      NotificationCenter.default.post(name: .renderStyleDidChange, object: newValue)
    }
  }

  public func toggle() { current = (current == .swiftui ? .uikit : .swiftui) }
}

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

  @MainActor
  private static func styleIcon(_ style: RenderStyle) -> String? {
    switch style {
    case .swiftui: return "list.bullet"
    case .uikit: return "square.grid.2x2"
    }
  }
}
#endif  // targetEnvironment(macCatalyst)
