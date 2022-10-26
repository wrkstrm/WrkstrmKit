#if canImport(UIKit)
import UIKit

public protocol Indexable {

  associatedtype Item: Equatable

  var items: [[Item]] { get }

  func item(for path: IndexPath) -> Item

  func indexPath(for item: Item) -> IndexPath?
}

public extension Indexable {

  var numberOfSections: Int { items.count }

  func numberOfItems(in section: Int) -> Int { items[section].count }

  func item(for path: IndexPath) -> Item { items[path.section][path.item] }

  func indexPath(for item: Item) -> IndexPath? {
    for (index, section) in items.enumerated() {
      if let row = section.firstIndex(of: item) {
        return IndexPath(item: row, section: index)
      }
    }
    return nil
  }
}

extension Array: Indexable where Element: Equatable {

  public typealias Item = Element

  public var items: [[Item]] { [self] }
}
#endif  // canImport(UIKit)
