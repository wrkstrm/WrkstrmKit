#if canImport(UIKit)
import UIKit

open class CollectionViewController<Model: CollectionViewDisplayable>: UICollectionViewController {
  open var displayableModel: Model? {
    didSet {
      if let displayableModel {
        genericDataSource = displayableModel.dataSource()
      }
    }
  }

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
