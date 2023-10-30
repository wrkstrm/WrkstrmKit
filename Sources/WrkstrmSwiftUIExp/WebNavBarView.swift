#if canImport(UIKit)
import SwiftUI
import UIKit
import WrkstrmCrossKit

public struct WebNavBarView: SwiftUI.View {

  @ObservedObject public var webViewState: WebView.State

  public init(webViewState: WebView.State) {
    self.webViewState = webViewState
  }

  public var body: some SwiftUI.View {
    HStack {
      Spacer()
      BackButton(webViewState: webViewState)
      Spacer()
      ForwardButton(webViewState: webViewState)
      Spacer()
      LoadingButton(webViewState: webViewState)
      Spacer()
      //      ShareButton(webViewState: webViewState)
      //      Spacer()
    }
  }
}

// MARK: - Nav Buttons

extension WebNavBarView {

  public struct LoadingButton: SwiftUI.View {

    @ObservedObject var webViewState: WebView.State

    public var reloadImage: UIImage {
      webViewState.isLoading ? .arrowCircle : .arrowClockwise
    }

    public var body: some SwiftUI.View {
      Button(
        action: { webViewState.reload() },
        label: { Image(uiImage: reloadImage).padding() })
    }
  }

  public struct BackButton: SwiftUI.View {

    @ObservedObject var webViewState: WebView.State

    public var body: some SwiftUI.View {
      Button(
        action: { webViewState.goBack() },
        label: { Image(uiImage: .chevronLeft).padding() })
        .disabled(!webViewState.canGoBack)
    }
  }

  public struct ForwardButton: SwiftUI.View {

    @ObservedObject public var webViewState: WebView.State

    public var body: some SwiftUI.View {
      Button(
        action: { webViewState.goForward() },
        label: { Image(uiImage: .chevronRight).padding() })
        .disabled(!webViewState.canGoForward)
    }
  }

  //  public struct ShareButton: View {
  //
  //    @ObservedObject var webViewState: WebView.State
  //
  //    public var body: some View {
  //      let defaultURL = URL(string: "https://http.cat/404")!
  //      return PresentationLink(
  //        destination: ActivityViewController(urls: [webViewState.currentURL ?? defaultURL]),
  //        label: { Image(systemName: "square.and.arrow.up").padding() })
  //    }
  //  }
}

#if DEBUG
struct WebNavBarViewPreviews: PreviewProvider {

  public static var previews: some SwiftUI.View {
    WebNavBarView(webViewState: WebView.State())
  }
}
#endif  // DEBUG
#endif  // canImport(UIKit)
