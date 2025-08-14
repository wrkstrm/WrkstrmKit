#if canImport(UIKit)
  import UIKit
  import WrkstrmCrossKit

  /// A model that provides the data and cell configuration for a
  /// `UICollectionView`.
  ///
  /// Conforming types describe their sections and rows and specify which
  /// `UICollectionViewCell` should be used for each item.
  ///
  /// ### Usage Example
  /// ```swift
  /// struct Book: CollectionReusableItem {
  ///   let title: String
  ///   var collectionReusableCell: CollectionReusableCell.Type { TitleCell.self }
  /// }
  ///
  /// struct Library: CollectionViewDisplayable {
  ///   typealias Item = Book
  ///   var items: [[Book]]
  /// }
  ///
  /// let library = Library(items: [[Book(title: "1984")]])
  /// let dataSource = library.dataSource()
  /// ```
  public protocol CollectionViewDisplayable: Indexable where Item: CollectionReusableItem {
    /// Returns the type of cell used to render the item at the given index path.
    func reusableCell(for path: IndexPath) -> CollectionReusableCell.Type

    /// Creates a type-safe data source backed by the receiver.
    func dataSource(config: CollectionViewDataSource<Self>.CellConfig?) -> CollectionViewDataSource<
      Self
    >

    /// Provides an optional supplementary view (such as headers or footers)
    /// for the given location in the collection view.
    func supplementaryElementView(
      for collectionView: UICollectionView,
      of kind: String,
      at indexPath: IndexPath,
    ) -> UICollectionReusableView?
  }

  @MainActor extension CollectionViewDisplayable {
    /// Resolves the cell type for the item at `path` using its
    /// `collectionReusableCell` property.
    public func reusableCell(for path: IndexPath) -> CollectionReusableCell.Type {
      item(for: path).collectionReusableCell
    }

    /// Creates a `CollectionViewDataSource` for the model.
    /// - Parameter config: Optional configuration called for each cell.
    /// - Returns: A configured collection view data source for the model.
    public func dataSource(config: CollectionViewDataSource<Self>.CellConfig? = nil)
      -> CollectionViewDataSource<Self>
    {
      CollectionViewDataSource(model: self, config: config)
    }

    /// Default implementation that returns `nil`, indicating no supplementary view.
    /// Override to provide headers or footers for the collection view.
    public func supplementaryElementView(
      for _: UICollectionView,
      of _: String,
      at _: IndexPath,
    ) -> UICollectionReusableView? {
      nil
    }
  }

  extension Array: @MainActor CollectionViewDisplayable where Element: CollectionReusableItem {
    /// Convenience factory for producing a data source backed by the array.
    @MainActor public func collectionDataSource(
      config: CollectionViewDataSource<[Element]>.CellConfig? = nil,
    )
      -> CollectionViewDataSource<[Element]>
    {
      CollectionViewDataSource(model: self, config: config)
    }
  }
#endif
