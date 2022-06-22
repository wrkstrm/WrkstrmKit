#if canImport(UIKit)
import UIKit
import WrkstrmCrossKit
import WrkstrmFoundation
import WrkstrmMain

extension JSON.Value: TableReusableItem {

  public var tableReusableCell: TableReusableCell.Type {
    switch self {

    case .integer:
      return JSON.IntegerCell.self

    case .double:
      return JSON.DoubleCell.self

    case .string:
      return JSON.StringCell.self

    case .date:
      return JSON.DateCell.self

    case .array:
      return JSON.ArrayCell.self

    case .dictionary:
      return JSON.DictionaryCell.self

    case .any:
      return JSON.AnyCell.self
    }
  }
}

extension JSON {

  public static let registrar =
    Registrar(classes: [
      JSON.BasicCell.self,
      JSON.IntegerCell.self,
      JSON.DoubleCell.self,
      JSON.StringCell.self,
      JSON.DateCell.self,
      JSON.AnyCell.self,
    ])

  public struct Displayable: TableViewDisplayable {

    let jsonArray: [JSONDictionary]

    var dateKeyFuzzyOverride: [String]?

    public init(jsonArray: [JSONDictionary], dateKeyFuzzyOverride: [String]? = nil) {
      self.jsonArray = jsonArray
      self.dateKeyFuzzyOverride = dateKeyFuzzyOverride
    }

    public var items: [[Value]] {
      let values = jsonArray.map { (json: JSONDictionary) -> [Value] in
        let sortedJSON = json.lazy.sorted { $0.key < $1.key }
        return sortedJSON.map { key, anyValue -> Value in
          guard let fuzzyKeys = dateKeyFuzzyOverride else {
            return self.generateValue(key, anyValue: anyValue)
          }
          for fuzzyKey in fuzzyKeys where key.lowercased().contains(fuzzyKey.lowercased()) {
            return self.generateDateValue(key, anyValue: anyValue)
          }
          return self.generateValue(key, anyValue: anyValue)
        }
      }
      return values
    }

    public func title(for section: Int) -> String? {
      .localizedStringWithFormat("Item %@", (section + 1).integerString())
    }

    func generateDateValue(_ key: String, anyValue: Any) -> Value {
      guard
        let dateString = anyValue as? String,
        let date = DateFormatter.iso8601.date(from: dateString)
      else { return .date(key, Date()) }
      return .date(key, date)
    }

    func generateValue(_ key: String, anyValue: Any) -> Value {
      switch anyValue {

      case let value as Int:
        return .integer(key, value)

      case let value as Double:
        return .double(key, value)

      case let value as String:
        return .string(key, value)

      case let value as Date:
        return .date(key, value)

      case let value as [JSONDictionary]:
        return .array(key, EquatableArray.dictionary(value))

      case let value as [Any]:
        return .array(key, EquatableArray.any(value))

      case let value as JSONDictionary:
        return .dictionary(key, EquatableDictionary.any(value))

      default:
        return .any(key, "\(anyValue)")
      }
    }
  }
}

public protocol JSONTableViewDisplayable {

  func jsonDictionaryDataSource(config: TableViewDataSource<JSON.Displayable>.CellConfig?)
    -> TableViewDataSource<JSON.Displayable>
}

extension JSONTableViewDisplayable where Self: Codable {

  public func convertToJSONDictionary() -> JSONDictionary {

    // swiftlint:disable:next force_try
    let data = try! JSONEncoder.default.encode(self)

    // swiftlint:disable:next force_try
    return try! JSONSerialization.jsonObject(
      with: data,
      options: .allowFragments) as! JSONDictionary
    // swiftlint:disable:previous force_cast
  }

  public func jsonDictionaryDataSource(
    config: TableViewDataSource<JSON.Displayable>
      .CellConfig? = nil) -> TableViewDataSource<JSON.Displayable> {

    let displayble =
      JSON.Displayable(
        jsonArray: [convertToJSONDictionary()],
        dateKeyFuzzyOverride: ["time", "date"])
    let dataSource = displayble.dataSource(config: config)
    dataSource.registrar = JSON.registrar
    return dataSource
  }
}
#endif
