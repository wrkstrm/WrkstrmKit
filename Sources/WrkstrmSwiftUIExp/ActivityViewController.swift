import SwiftUI

#if canImport(UIKit)
  import UIKit
  import WrkstrmCrossKit

  public struct ActivityViewController: UIViewControllerRepresentable {
    private var urls: [URL]

    public init(urls: [URL]) {
      self.urls = urls
    }

    // MARK: - UIViewRepresentable

    public func makeUIViewController(context _: Context) -> UIActivityViewController {
      UIActivityViewController(activityItems: urls, applicationActivities: nil)
    }

    public func updateUIViewController(_: UIActivityViewController, context _: Context) {}
  }
#endif
