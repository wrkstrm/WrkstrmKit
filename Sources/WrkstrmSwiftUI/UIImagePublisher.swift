import Combine
import SwiftUI

#if canImport(UIKit)
import UIKit

open class UIImagePublisher: ObservableObject {
  public var imageCancellable: AnyCancellable?

  @Published public var uiImage: UIImage

  public init(_ uiImage: UIImage) {
    self.uiImage = uiImage
  }
}
#endif
