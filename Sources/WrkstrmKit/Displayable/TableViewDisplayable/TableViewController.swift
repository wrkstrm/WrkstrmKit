#if canImport(UIKit)
import UIKit
import CommonLog

private let estimatedRowHeight: CGFloat = 200

typealias UISearchProtocols = UISearchBarDelegate & UISearchControllerDelegate
  & UISearchResultsUpdating

public class Search<Model: TableViewDisplayable> {
  public struct Filter {
    public typealias Match = (Model.Item, String) -> Bool

    let title: String
    let test: Match

    public init(title: String, test: @escaping Match) {
      self.title = title
      self.test = test
    }
  }

  public struct Sort {
    public typealias Order = (Model.Item, Model.Item) -> Bool

    let title: String
    let test: Order?

    public init(title: String, test: Order?) {
      self.title = title
      self.test = test
    }
  }

  public enum ScopeMode {
    case filter([Filter])
    case sort([Sort])
  }

  public var last: String = ""

  public var main: [Filter.Match]

  public var model: Model?

  public var scopes: (mode: ScopeMode, default: Int)?

  public init(
    scopes: (mode: ScopeMode, default: Int)? = nil,
    filter: @escaping Filter.Match,
  ) {
    self.scopes = scopes
    main = [filter]
  }

  public init(
    scopes: (mode: ScopeMode, default: Int)? = nil,
    filters: [Filter.Match],
  ) {
    self.scopes = scopes
    main = filters
  }
}

open class TableViewController<Model: TableViewDisplayable>: UITableViewController,
  UISearchProtocols
{
  // MARK: - TableViewDisplayable Variables

  open var displayableModel: Model? {
    didSet {
      if let displayableModel {
        search?.model = displayableModel
        genericDataSource = displayableModel.dataSource()
      }
    }
  }

  open var genericDataSource: TableViewDataSource<Model>? {
    didSet {
      if let registrar = genericDataSource?.registrar {
        tableView.addRegistrar(registrar)
      }
      tableView.dataSource = genericDataSource
      tableView.reloadData()
    }
  }

  override public init(style: UITableView.Style) {
    super.init(style: style)
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: - UISearchController Variables

  open var search: Search<Model>? {
    didSet {
      if let search {
        definesPresentationContext = true
        searchController = UISearchController(searchResultsController: nil)
        search.model = displayableModel
      } else {
        definesPresentationContext = false
        searchController?.removeFromParent()
        searchController = nil
      }
    }
  }

  public var searchController: UISearchController? {
    didSet {
      searchController?.obscuresBackgroundDuringPresentation = false
      searchController?.delegate = self
      searchController?.searchResultsUpdater = self
      if #available(iOS 16.0, *) {
        searchController?.scopeBarActivation = .automatic
      }
      searchController?.searchBar.autocapitalizationType = .none
      searchController?.searchBar.delegate = self  // Monitor when the search button is tapped.

      // Place the search bar in the navigation bar.
      switch search?.scopes?.mode {
      case .filter(let scopes):
        searchController?.searchBar.scopeButtonTitles = scopes.map(\.title)
        searchController?.searchBar.selectedScopeButtonIndex = search?.scopes?.default ?? 0

      case .sort(let scopes):
        searchController?.searchBar.scopeButtonTitles = scopes.map(\.title)
        searchController?.searchBar.selectedScopeButtonIndex = search?.scopes?.default ?? 0

      case .none:
        searchController?.searchBar.scopeButtonTitles = nil
      }
      if #available(iOS 11.0, *) {
        navigationItem.searchController = searchController
      }
      // Make the search bar always visible.
      if #available(iOS 11.0, *) {
        navigationItem.hidesSearchBarWhenScrolling = false
      }
      definesPresentationContext = false
    }
  }

  override open func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = estimatedRowHeight
  }

  // MARK: - UISearchControllerDelegate

  @objc(updateSearchResultsForSearchController:)
  open func updateSearchResults(for searchController: UISearchController) {
    // Strip out all the leading and trailing spaces.
    Log.kit.verbose("isActive: \(searchController.isActive)")
    guard let search else { return }
    let index = searchController.searchBar.selectedScopeButtonIndex
    var scopedItems = search.model?.items
    switch search.scopes?.mode {
    case .filter(let scopes):
      let current = scopes[index]
      scopedItems = scopedItems?.compactMap { section in
        section.filter { current.test($0, current.title) }
      }
      Log.kit.verbose(current)

    case .sort(let scopes):
      if let test = scopes[index].test {
        scopedItems = scopedItems?.compactMap { section in
          section.sorted { test($0, $1) }
        }
      }

    default:
      break
    }

    guard
      let strippedString = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces),
      !strippedString.isEmpty
    else {
      if search.last.isEmpty {
        genericDataSource = TableViewDataSource(items: scopedItems ?? [[]])
      }
      return
    }
    // Update the filtered array based on the search text.
    let items = scopedItems?.compactMap { section in
      section.filter { item in
        search.main.reduce(into: false) { matchResult, test in
          guard matchResult || test(item, strippedString) == true else { return }
          matchResult = true
        }
      }
    }
    genericDataSource = TableViewDataSource(items: items ?? [[]])
  }

  // MARK: - UISearchControllerDelegate

  public func didDismissSearchController(_ searchController: UISearchController) {
    searchController.searchBar.text = search?.last
  }

  // MARK: - UISearchbarDelegate

  public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    guard let lastSearchText = searchBar.text, !lastSearchText.isEmpty else { return }
    search?.last = lastSearchText
  }

  public func searchBar(_: UISearchBar, textDidChange searchText: String) {
    search?.last = searchText
    if searchText.isEmpty {
      displayableModel = search?.model
    }
  }

  public func searchBarCancelButtonClicked(_: UISearchBar) {
    search?.last = ""
    displayableModel = search?.model
  }
}
#endif
