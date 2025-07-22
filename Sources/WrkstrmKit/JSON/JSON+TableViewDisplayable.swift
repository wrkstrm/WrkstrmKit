#if canImport(UIKit)
  import UIKit
  import WrkstrmCrossKit
  import WrkstrmFoundation
  import WrkstrmMain

  extension JSON.KVPair: TableReusableItem {
    public var tableReusableCell: TableReusableCell.Type {
      switch self {
      case .integer:
        JSON.IntegerCell.self

      case .double:
        JSON.DoubleCell.self

      case .string:
        JSON.StringCell.self

      case .date:
        JSON.DateCell.self

      case .array:
        JSON.ArrayCell.self

      case .dictionary:
        JSON.DictionaryCell.self

      case .any:
        JSON.AnyCell.self
      }
    }
  }

  extension JSON {
    public struct Displayable: @MainActor TableViewDisplayable {
      let jsonArray: [JSON.AnyDictionary]

      var dateKeyFuzzyOverride: [String]?

      public init(jsonArray: [JSON.AnyDictionary], dateKeyFuzzyOverride: [String]? = nil) {
        self.jsonArray = jsonArray
        self.dateKeyFuzzyOverride = dateKeyFuzzyOverride
      }

      public var items: [[KVPair]] {
        let kvPairs = jsonArray.map { (json: JSON.AnyDictionary) -> [KVPair] in
          let sortedJSON = json.lazy.sorted { $0.key < $1.key }
          return sortedJSON.map { key, anyValue -> KVPair in
            guard let fuzzyKeys = dateKeyFuzzyOverride else {
              return generateKVPair(key, anyValue: anyValue)
            }
            for fuzzyKey in fuzzyKeys where key.lowercased().contains(fuzzyKey.lowercased()) {
              return generateDateValue(key, anyValue: anyValue)
            }
            return generateKVPair(key, anyValue: anyValue)
          }
        }
        return kvPairs
      }

      public func title(for section: Int) -> String? {
        .localizedStringWithFormat("Item %@", (section + 1).integerString())
      }

      func generateDateValue(_ key: String, anyValue: Any) -> KVPair {
        guard
          let dateString = anyValue as? String,
          let date = DateFormatter.iso8601.date(from: dateString)
        else { return .date(key, Date()) }
        return .date(key, date)
      }

      func generateKVPair(_ key: String, anyValue: Any) -> KVPair {
        switch anyValue {
        case let value as Int:
          .integer(key, value)

        case let value as Double:
          .double(key, value)

        case let value as String:
          .string(key, value)

        case let value as Date:
          .date(key, value)

        case let value as [JSON.AnyDictionary]:
          .array(key, AnyEquatableArrayEnum.dictionary(value))

        case let value as [Any]:
          .array(key, AnyEquatableArrayEnum.any(value))

        case let value as JSON.AnyDictionary:
          .dictionary(key, AnyEquatableDictionaryEnum.any(value))

        default:
          .any(key, "\(anyValue)")
        }
      }
    }
  }

  public protocol JSONTableViewDisplayable {
    func jsonDictionaryDataSource(config: TableViewDataSource<JSON.Displayable>.CellConfig?)
      -> TableViewDataSource<JSON.Displayable>
  }

  extension JSONTableViewDisplayable where Self: Codable {
    public func convertToJSONDictionary() -> JSON.AnyDictionary {
      // swiftlint:disable:next force_try
      let data = try! JSONEncoder.default.encode(self)

      // swiftlint:disable:next force_try
      return try! JSONSerialization.jsonObject(
        with: data,
        options: .allowFragments,
      ) as! JSON.AnyDictionary
      // swiftlint:disable:previous force_cast
    }

    @MainActor public func jsonDictionaryDataSource(
      config: TableViewDataSource<JSON.Displayable>
        .CellConfig? = nil,
    ) -> TableViewDataSource<JSON.Displayable> {
      let displayble =
        JSON.Displayable(
          jsonArray: [convertToJSONDictionary()],
          dateKeyFuzzyOverride: ["time", "date"],
        )
      let dataSource = displayble.dataSource(config: config)
      dataSource.registrar =
        Registrar(classes: [
          JSON.BasicCell.self,
          JSON.IntegerCell.self,
          JSON.DoubleCell.self,
          JSON.StringCell.self,
          JSON.DateCell.self,
          JSON.AnyCell.self,
        ])
      return dataSource
    }
  }
#endif
