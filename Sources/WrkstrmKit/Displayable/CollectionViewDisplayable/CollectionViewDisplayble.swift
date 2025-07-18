#if canImport(UIKit)
import UIKit
import WrkstrmCrossKit

public protocol CollectionViewDisplayable: Indexable where Item: CollectionReusableItem {
  func reusableCell(for path: IndexPath) -> CollectionReusableCell.Type

  func dataSource(config: CollectionViewDataSource<Self>.CellConfig?) -> CollectionViewDataSource<
    Self
  >

  func supplementaryElementView(
    for collectionView: UICollectionView,
    of kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView?
}

@MainActor extension CollectionViewDisplayable {
  public func reusableCell(for path: IndexPath) -> CollectionReusableCell.Type {
    item(for: path).collectionReusableCell
  }

  public func dataSource(config: CollectionViewDataSource<Self>.CellConfig? = nil)
    -> CollectionViewDataSource<Self>
  {
    CollectionViewDataSource(model: self, config: config)
  }

  public func supplementaryElementView(
    for _: UICollectionView,
    of _: String,
    at _: IndexPath
  ) -> UICollectionReusableView? {
    nil
  }
}

extension Array: @MainActor CollectionViewDisplayable where Element: CollectionReusableItem {
  @MainActor public func collectionDataSource(
    config: CollectionViewDataSource<[Element]>.CellConfig? = nil
  )
    -> CollectionViewDataSource<[Element]>
  {
    CollectionViewDataSource(model: self, config: config)
  }
}
#endif
