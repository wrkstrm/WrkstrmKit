#if canImport(UIKit)
import UIKit
import WrkstrmFoundation
import WrkstrmLog
import WrkstrmMain

extension JSONTableViewController: @preconcurrency Injectable {
  public func inject(_ resource: TableViewDataSource<JSON.Displayable>) {
    genericDataSource = resource
  }

  public func assertDependencies() {
    assert(genericDataSource != nil)
  }
}

open class JSONTableViewController: TableViewController<JSON.Displayable> {
  override open func tableView(
    _ tableView: UITableView,
    willSelectRowAt indexPath: IndexPath
  ) -> IndexPath? {
    tableView.indexPathsForSelectedRows?.forEach { tableView.deselectRow(at: $0, animated: true) }
    guard let item = genericDataSource?.modelFor(indexPath: indexPath) else { return nil }
    switch item {
      case .array(_, let jsonArray):
        switch jsonArray {
          case .dictionary(let jsonArray):
            return jsonArray.isEmpty ? nil : indexPath

          case .any:
            return nil
        }

      case .dictionary(_, let equatableJsonDictionary):
        switch equatableJsonDictionary {
          case .any(let jsonDictionary):
            return jsonDictionary.isEmpty ? nil : indexPath
        }

      default:
        return nil
    }
  }

  override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.indexPathsForSelectedRows?.forEach { tableView.deselectRow(at: $0, animated: true) }
    guard let item = genericDataSource?.modelFor(indexPath: indexPath) else { Log.kit.guard() }

    var jsonTuple: (key: String, jsonArray: [JSON.AnyDictionary])?
    switch item {
      case .dictionary(_, let equatableJSONDictionary):
        switch equatableJSONDictionary {
          case .any(let jsonDictionary):
            jsonTuple = (key: "", jsonArray: [jsonDictionary])
        }

      case .array(let key, let equatableJsonArray):
        switch equatableJsonArray {
          case .dictionary(let array):
            jsonTuple = (key: key, jsonArray: array)

          default:
            break
        }

      default:
        break
    }

    if let tuple = jsonTuple {
      let controller: JSONTableViewController = .init(style: .plain)
      var jsonDisplayble = JSON.Displayable(jsonArray: tuple.jsonArray)
      jsonDisplayble.dateKeyFuzzyOverride = ["time", "date"]
      controller.title = tuple.key.capitalized
      controller.inject(jsonDisplayble.dataSource())
      navigationController?.pushViewController(controller, animated: true)
    }
  }
}
#endif
