import SwiftUI

#if canImport(UIKit)
import UIKit

public struct PageViewController: UIViewControllerRepresentable {
  //  @Binding public var currentPage: Int

  var controllers: [UIViewController]

  public init(controllers: [UIViewController], currentPage _: Binding<Int>) {
    self.controllers = controllers
    //    $currentPage = currentPage
  }

  public func makeUIViewController(context: Context) -> UIPageViewController {
    let pageViewController = UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal)
    pageViewController.dataSource = context.coordinator
    pageViewController.delegate = context.coordinator

    return pageViewController
  }

  public func updateUIViewController(_: UIPageViewController, context _: Context) {
    //    uiViewController.setViewControllers([controllers[currentPage]],
    //                                        direction: .forward,
    //                                        animated: true)
  }
}

// MARK: - Coordinator

extension PageViewController {
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  public class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var parent: PageViewController

    init(_ pageViewController: PageViewController) {
      parent = pageViewController
    }

    public func pageViewController(
      _: UIPageViewController,
      viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
      guard let index = parent.controllers.firstIndex(of: viewController) else {
        return nil
      }
      if index == 0 {
        return parent.controllers.last
      }
      return parent.controllers[index - 1]
    }

    public func pageViewController(
      _: UIPageViewController,
      viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
      guard let index = parent.controllers.firstIndex(of: viewController) else {
        return nil
      }
      if index + 1 == parent.controllers.count {
        return parent.controllers.first
      }
      return parent.controllers[index + 1]
    }

    public func pageViewController(
      _: UIPageViewController,
      didFinishAnimating _: Bool,
      previousViewControllers _: [UIViewController],
      transitionCompleted _: Bool
    ) {
      //      if completed,
      //        let visibleViewController = pageViewController.viewControllers?.first,
      //        let index = parent.controllers.firstIndex(of: visibleViewController) {
      //        parent.currentPage = index
      //      }
    }
  }
}
#endif
