import Combine
import SwiftUI
import WebKit

#if canImport(UIKit)

// MARK: - WebView

public struct WebView: UIViewRepresentable {

  @ObservedObject public var state = State()

  public init() {}

  public func load(_ url: URL) {
    state.rootURL = url
  }

  // MARK: - UIViewRepresentable

  public func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView(frame: .zero)
    webView.navigationDelegate = context.coordinator
    context.coordinator.parentUIView = webView
    context.coordinator.load()
    return webView
  }

  public func updateUIView(_: WKWebView, context _: Context) {}
}

// MARK: - State

public extension WebView {

  class State: ObservableObject {

    weak var coordinator: Coordinator?

    public let willChange = PassthroughSubject<State, Never>()

    public var isLoading = true {
      didSet { willChange.send(self) }
    }

    public var canGoBack = false {
      didSet { willChange.send(self) }
    }

    public var canGoForward = false {
      didSet { willChange.send(self) }
    }

    public var rootURL: URL? {
      didSet { willChange.send(self) }
    }

    public var currentURL: URL? { coordinator?.currentURL }

    public init() {}

    public func load(url: URL) { rootURL = url }

    @discardableResult
    public func reload() -> WKNavigation? { coordinator?.reload() }

    @discardableResult
    public func goBack() -> WKNavigation? { coordinator?.goBack() }

    @discardableResult
    public func goForward() -> WKNavigation? { coordinator?.goForward() }
  }
}

// MARK: - Coordinator

public extension WebView {

  func makeCoordinator() -> Coordinator {
    let coordinator = Coordinator(self)
    state.coordinator = coordinator
    return coordinator
  }

  class Coordinator: NSObject {

    weak var parentUIView: WKWebView?

    var parent: WebView

    var currentURL: URL? { parentUIView?.url }

    init(_ parent: WebView) {
      self.parent = parent
    }

    @discardableResult
    func load() -> WKNavigation? {
      if let url = parent.state.rootURL {
        return parentUIView?.load(URLRequest(url: url))
      }
      return nil
    }

    @discardableResult
    func reload() -> WKNavigation? {
      parentUIView?.reload()
    }

    @discardableResult
    func goBack() -> WKNavigation? {
      if parentUIView?.canGoBack == true {
        return parentUIView?.goBack()
      }
      return nil
    }

    @discardableResult
    func goForward() -> WKNavigation? {
      if parentUIView?.canGoForward == true {
        return parentUIView?.goForward()
      }
      return nil
    }
  }
}

// MARK: - WKNavigationDelegate

extension WebView.Coordinator: WKNavigationDelegate {

  func updateState(isLoading: Bool, webView: WKWebView) {
    parent.state.isLoading = isLoading
    parent.state.canGoForward = webView.canGoForward
    parent.state.canGoBack = webView.canGoBack
  }

  public func webView(_ webView: WKWebView, didCommit _: WKNavigation!) {
    updateState(isLoading: true, webView: webView)
  }

  public func webView(
    _ webView: WKWebView,
    didFail _: WKNavigation!,
    withError _: Error)
  {
    updateState(isLoading: false, webView: webView)
  }

  public func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
    updateState(isLoading: false, webView: webView)
  }
}
#endif
