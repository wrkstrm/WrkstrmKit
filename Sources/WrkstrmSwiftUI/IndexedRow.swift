#if canImport(SwiftUI)
  import SwiftUI

  /// A wrapper around an element in a collection that maintains a stable
  /// identifier and index for use in SwiftUI lists.
  ///
  /// Use ``IndexedRow`` to provide identity information when iterating over
  /// collections that might mutate.
  ///
  /// - Example:
  ///   ```swift
  ///   let row = IndexedRow(id: 1, index: 0, element: "A")
  ///   print(row.element) // "A"
  ///   ```
  public final class IndexedRow<M>: Identifiable, ObservableObject {
    /// The stable identifier of the row.
    public let id: Int

    /// The position of the row within its collection.
    public let index: Int

    /// The element associated with this row.
    @Published public var element: M

    /// Creates a new ``IndexedRow`` with the provided identifier, index and element.
    /// - Parameters:
    ///   - id: A unique identifier for the row.
    ///   - index: The position of the element in the collection.
    ///   - element: The underlying element.
    /// - Example:
    ///   ```swift
    ///   let row = IndexedRow(id: 42, index: 3, element: "Banana")
    ///   ```
    @_specialize(where M:_Trivial)
    public init(id: Int, index: Int, element: M) {
      self.id = id
      self.index = index
      self.element = element
    }
  }
#endif
