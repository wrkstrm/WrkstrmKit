#if canImport(UIKit)
  import UIKit
  import WrkstrmCrossKit

  /// A placeholder supplementary view used when the model does not provide one.
  public class PlaceholderSupplementaryCell: UICollectionViewCell {}

  /// A placeholder cell used when a concrete cell has not been registered.
  public class PlaceholderCollectionCell: UICollectionViewCell {}

  /// Bridges a `CollectionViewDisplayable` model to `UICollectionView`'s data
  /// source requirements.
  ///
  /// ### Usage Example
  /// ```swift
  /// let dataSource = library.dataSource()
  /// collectionView.dataSource = dataSource
  /// ```
  public class CollectionViewDataSource<Model: CollectionViewDisplayable>: NSObject,
    UICollectionViewDataSource, @preconcurrency Indexable
  {
    /// Closure type used to configure cells after dequeuing.
    public typealias CellConfig = (UICollectionViewCell, Model.Item, IndexPath) -> Void

    private var displayable: Model

    public let items: [[Model.Item]]

    private let reuseIdentifiers: [[String]]

    public var registrar: Registrar?

    var config: CellConfig?

    /// Creates a data source for the supplied model.
    /// - Parameters:
    ///   - model: The collection view model providing the data.
    ///   - config: Optional closure executed for each cell after it has been dequeued.
    init(model: Model, config: CellConfig?) {
      displayable = model
      items = model.items
      var registrationIdentifiers: [[String]] = []
      for (section, elements) in items.enumerated() {
        var sectionIdentifiers: [String] = []
        for index in elements.indices {
          let path: IndexPath = .init(row: index, section: section)

          let cellType = model.reusableCell(for: path)
          sectionIdentifiers.append(cellType.reuseIdentifier())
        }
        registrationIdentifiers.append(sectionIdentifiers)
      }
      reuseIdentifiers = registrationIdentifiers
      self.config = config
    }

    /// Returns the model item for the specified index path, if it exists.
    public func model(for indexPath: IndexPath) -> Model.Item? {
      let sectionIndex = indexPath.section
      let rowIndex = indexPath.row
      if sectionIndex < items.count {
        let section = items[sectionIndex]
        if rowIndex < section.count {
          return section[rowIndex]
        }
      }
      return nil
    }

    /// Returns the number of sections in the data source.
    public func numberOfSections(in _: UICollectionView) -> Int { numberOfSections }

    /// Supplies a supplementary view for the collection view by asking the model
    /// or falling back to a placeholder.
    public func collectionView(
      _ collectionView: UICollectionView,
      viewForSupplementaryElementOfKind kind: String,
      at indexPath: IndexPath,
    ) -> UICollectionReusableView {
      guard
        let view = displayable.supplementaryElementView(
          for: collectionView,
          of: kind,
          at: indexPath,
        )
      else {
        let identifier = PlaceholderSupplementaryCell.reuseIdentifier()
        collectionView.register(
          UICollectionViewCell.self,
          forSupplementaryViewOfKind: kind,
          withReuseIdentifier: identifier,
        )
        return collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: identifier,
          for: indexPath,
        )
      }
      return view
    }

    /// Returns the number of items in the specified section.
    public func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      numberOfItems(in: section)
    }

    /// Dequeues and configures a cell for the item at the supplied index path.
    public func collectionView(
      _ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath,
    ) -> UICollectionViewCell {
      let cellType = item(for: indexPath).collectionReusableCell
      if cellType == PlaceholderCollectionCell.self {
        collectionView.register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier())
      }
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: cellType.reuseIdentifier(),
        for: indexPath,
      )
      let cellItem = displayable.item(for: indexPath)
      config?(cell, cellItem, indexPath)
      (cell as ReusableCell).prepare?(for: cellItem, path: indexPath)
      return cell
    }
  }
#endif
