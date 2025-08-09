#if canImport(SwiftUI) && canImport(UIKit)
  import Combine
  import SwiftUI
  import UIKit

  open class UIImagePublisher: ObservableObject {
    public var imageCancellable: AnyCancellable?

    @Published public var uiImage: UIImage

    public init(_ uiImage: UIImage) {
      self.uiImage = uiImage
    }
  }
#endif
