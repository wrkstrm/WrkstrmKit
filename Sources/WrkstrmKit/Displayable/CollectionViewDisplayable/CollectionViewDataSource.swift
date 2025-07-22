#if canImport(UIKit)
  import UIKit
  import WrkstrmCrossKit

  public class PlaceholderSupplementaryCell: UICollectionViewCell {}

  public class PlaceholderCollectionCell: UICollectionViewCell {}

  public class CollectionViewDataSource<Model: CollectionViewDisplayable>: NSObject,
    UICollectionViewDataSource, @preconcurrency Indexable
  {
    public typealias CellConfig = (UICollectionViewCell, Model.Item, IndexPath) -> Void

    private var displayable: Model

    public let items: [[Model.Item]]

    private let reuseIdentifiers: [[String]]

    public var registrar: Registrar?

    var config: CellConfig?

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

    public func numberOfSections(in _: UICollectionView) -> Int { numberOfSections }

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

    public func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      numberOfItems(in: section)
    }

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
