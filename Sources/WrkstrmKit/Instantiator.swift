#if canImport(UIKit)
import UIKit
import WrkstrmCrossKit
import WrkstrmFoundation
import WrkstrmMain

public protocol ControllerProvider {

  static func instantiate() -> UIViewController
}

public struct Instantiator {

  public var name: String

  public var detail: String

  public var provider: ControllerProvider.Type

  public init(name: String, detail: String, provider: ControllerProvider.Type) {
    self.name = name
    self.detail = detail
    self.provider = provider
  }
}

extension Instantiator: Equatable {

  public static func == (lhs: Instantiator, rhs: Instantiator) -> Bool {
    lhs.name == rhs.name && lhs.detail == rhs.detail && lhs.provider == rhs.provider
  }
}

extension Instantiator: TableReusableItem {

  public var tableReusableCell: TableReusableCell.Type { InstantiatorCell.self }
}

public class InstantiatorCell: UITableViewCell, StyleableCell {

  public static var cellStyle: UITableViewCell.CellStyle = .subtitle

  override public required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func prepare(for model: Any?, path _: IndexPath) {
    guard let experiment = model as? Instantiator else { return }
    textLabel?.text = experiment.name
    detailTextLabel?.text = experiment.detail
  }
}

extension SplitViewControllerInstantiator: Injectable {

  public func inject(_ resource: [Instantiator]) {
    genericDataSource = resource.tableDataSource()
  }

  // No asserts needed.
  public func assertDependencies() {}
}

public class SplitViewControllerInstantiator: TableViewController<[Instantiator]> {

  override public func viewDidLoad() {
    super.viewDidLoad()
    tableView.addRegistar(Registrar(classes: [InstantiatorCell.self], nibs: nil))
    tableView.separatorStyle = .none
  }

  override public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let item = genericDataSource?.item(for: indexPath) else { return }

    let navController =
      UINavigationController(rootViewController: item.provider.instantiate())
    navController.navigationBar.isTranslucent = true
    if let splitViewController = splitViewController {
      splitViewController.showDetailViewController(navController, sender: nil)
    } else if let navigationController = navigationController {
      navigationController.pushViewController(navController, animated: true)
    }
  }
}

#endif  // canImport(UIKit)
