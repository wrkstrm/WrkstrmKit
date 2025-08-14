#if canImport(UIKit)
  import UIKit

  /// A generic `UICollectionViewController` that renders a
  /// `CollectionViewDisplayable` model.
  ///
  /// Provide a model and the controller automatically creates the
  /// associated `CollectionViewDataSource` and registers the required cells.
  open class CollectionViewController<Model: CollectionViewDisplayable>: UICollectionViewController
  {
    /// The model driving the collection view. Setting this will create a new
    /// data source for the collection view.
    open var displayableModel: Model? {
      didSet {
        if let displayableModel {
          genericDataSource = displayableModel.dataSource()
        }
      }
    }

    /// The data source used by the collection view. Assigning a value will
    /// register any required cells and reload the view.
    open var genericDataSource: CollectionViewDataSource<Model>? {
      didSet {
        if let registrar = genericDataSource?.registrar {
          collectionView.add(registrar)
        }
        collectionView.dataSource = genericDataSource
        collectionView.reloadData()
      }
    }
  }
#endif
