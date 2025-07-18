#if canImport(UIKit)
import UIKit
import WrkstrmCrossKit

class PlaceholderTableViewCell: UITableViewCell {}

public class TableViewDataSource<Model: TableViewDisplayable>: NSObject,
  UITableViewDataSource, @preconcurrency Indexable
{
  public typealias CellConfig = ((model: Model.Item, cell: UITableViewCell), IndexPath) -> Void

  public let model: Model?

  public let items: [[Model.Item]]

  private var reusableTypes: [[ReusableCell.Type]]

  public var registrar: Registrar?

  public var config: CellConfig?

  public init(model: Model, registrar: Registrar? = nil, config: CellConfig? = nil) {
    self.model = model
    items = model.items
    self.config = config
    self.registrar = registrar
    reusableTypes = items.map { $0.map(\.tableReusableCell) }
  }

  init(items: [[Model.Item]], registrar: Registrar? = nil, config: CellConfig? = nil) {
    model = nil
    self.items = items
    self.config = config
    self.registrar = registrar
    reusableTypes = items.map { $0.map(\.tableReusableCell) }
  }

  public func modelFor(indexPath path: IndexPath) -> Model.Item? { item(for: path) }

  public func numberOfSections(in _: UITableView) -> Int { numberOfSections }

  public func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
    if let model {
      model.title(for: section)
    } else if numberOfSections > 1 {
      .localizedStringWithFormat("Item %@", (section + 1).integerString())
    } else {
      nil
    }
  }

  public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    numberOfItems(in: section)
  }

  public func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let reusableType = reusableTypes[indexPath.section][indexPath.row]
    if reusableType.reuseIdentifier() == PlaceholderTableViewCell.reuseIdentifier() {
      tableView.register(
        UITableViewCell.self,
        forCellReuseIdentifier: reusableType.reuseIdentifier()
      )
    }

    let cell: UITableViewCell!
    switch reusableType {
      case let styleableType as StyleableCell.Type:
        if let cachedCell =
          tableView.dequeueReusableCell(withIdentifier: styleableType.reuseIdentifier())
        {
          cell = cachedCell
        } else {
          cell =
            (styleableType.init(
              style: styleableType.cellStyle,
              reuseIdentifier: styleableType.reuseIdentifier()
            ) as! UITableViewCell)
          // swiftlint:disable:previous force_cast
          cell.prepareForReuse()
        }

      default:
        cell =
          tableView.dequeueReusableCell(
            withIdentifier: reusableType.reuseIdentifier(),
            for: indexPath
          )
    }

    let currentItem = item(for: indexPath)
    config?((model: currentItem, cell: cell), indexPath)
    (cell as TableReusableCell).prepare?(for: currentItem, path: indexPath)
    if let tableViewCell = cell as? TableViewCell {
      tableViewCell.tableView = tableView
    }
    return cell
  }
}
#endif
