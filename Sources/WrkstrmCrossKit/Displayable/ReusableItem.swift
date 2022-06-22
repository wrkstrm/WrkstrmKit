#if !canImport(WatchKit)
public protocol TableReusableItem: Equatable {

  var tableReusableCell: TableReusableCell.Type { get }
}

public protocol CollectionReusableItem: Equatable {

  var collectionReusableCell: CollectionReusableCell.Type { get }
}
#endif  // !canImport(WatchKit)
