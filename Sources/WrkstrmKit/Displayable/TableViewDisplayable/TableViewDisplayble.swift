#if canImport(UIKit)
import UIKit
import WrkstrmCrossKit

public protocol TableViewDisplayable: Indexable where Item: TableReusableItem {
  func reusableCell(for path: IndexPath) -> TableReusableCell.Type

  func title(for section: Int) -> String?

  func dataSource(config: TableViewDataSource<Self>.CellConfig?) -> TableViewDataSource<Self>
}

extension TableViewDisplayable {
  public func reusableCell(for path: IndexPath) -> TableReusableCell.Type {
    item(for: path).tableReusableCell
  }

  public func dataSource(config: TableViewDataSource<Self>.CellConfig? = nil)
    -> TableViewDataSource<Self>
  {
    TableViewDataSource(model: self, config: config)
  }
}

extension Array: TableViewDisplayable where Element: TableReusableItem {
  public func title(for _: Int) -> String? { nil }

  public func tableDataSource(
    config: TableViewDataSource<[Element]>.CellConfig? = nil) -> TableViewDataSource<[Element]>
  {
    TableViewDataSource(items: items, config: config)
  }
}
#endif
