import SwiftUI

public final class IndexedRow<M: Identifiable>: Identifiable, ObservableObject {
  public let id: Int

  public let index: Int

  @Published public var element: M

  @_specialize(where M: _Trivial)
  public init(id: Int, index: Int, element: M) {
    self.id = id
    self.index = index
    self.element = element
  }
}
