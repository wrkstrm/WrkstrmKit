import SwiftUI

#if canImport(UIKit)
  import UIKit

  @available(iOS 13.0, *)
  public struct PageControl: UIViewRepresentable {
    //  @Binding public var currentPage: Int

    public var numberOfPages: Int

    public init(numberOfPages: Int, currentPage _: Binding<Int>) {
      self.numberOfPages = numberOfPages
      //    self.$currentPage = currentPage
    }

    public func makeUIView(context: Context) -> UIPageControl {
      let control: UIPageControl = .init()
      control.numberOfPages = numberOfPages
      control.addTarget(
        context.coordinator,
        action: #selector(Coordinator.updateCurrentPage(sender:)),
        for: .valueChanged,
      )

      return control
    }

    public func updateUIView(_: UIPageControl, context _: Context) {
      //    uiView.currentPage = currentPage
    }
  }

  // MARK: - Coordinator

  extension PageControl {
    public func makeCoordinator() -> Coordinator {
      Coordinator(self)
    }

    public class Coordinator: NSObject {
      var control: PageControl

      init(_ control: PageControl) {
        self.control = control
      }

      @objc
      func updateCurrentPage(sender _: UIPageControl) {
        //      control.currentPage = sender.currentPage
      }
    }
  }
#endif
