import Foundation

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
