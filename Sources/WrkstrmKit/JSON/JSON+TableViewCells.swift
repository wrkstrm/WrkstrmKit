#if canImport(UIKit)
import UIKit
import WrkstrmFoundation
import WrkstrmLog

extension WrkstrmFoundation.JSON {

  open class BasicCell: UITableViewCell, StyleableCell {

    public static var cellStyle: UITableViewCell.CellStyle = .value1

    /// UITableViewCells instantiated from a UITableView's deque mechanism instantiates classes with
    ///  the `.default` style. This override allows for a particular style to be instantiated by a
    ///  subclass through the static `cellStyle` property.
    /// - Parameter style: The default style to be ignored.
    /// - Parameter reuseIdentifier: The cellReuseIdentifier. Usually "{Class}Identifier"
    override public required init(style _: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: Self.cellStyle, reuseIdentifier: reuseIdentifier)
    }

    public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }

    override public func prepareForReuse() {
      super.prepareForReuse()
      textLabel?.numberOfLines = 0
      detailTextLabel?.numberOfLines = 0
      selectionStyle = .none
    }
  }

  public class IntegerCell: BasicCell {

    public func prepare(for model: Any?, path _: IndexPath) {
      guard case let .integer(key, value)? = model as? JSON.Value else { Log.guard() }
      textLabel?.text = key.titlecased()
      detailTextLabel?.text = NumberFormatter.integer.string(for: value)
    }
  }

  public class DoubleCell: BasicCell {

    public func prepare(for model: Any?, path _: IndexPath) {
      guard case let .double(key, value)? = model as? JSON.Value else { Log.guard() }
      textLabel?.text = key.titlecased()
      detailTextLabel?.text = value.doubleString()
    }
  }

  public class StringCell: BasicCell {

    public func prepare(for model: Any?, path _: IndexPath) {
      guard case let .string(key, value)? = model as? JSON.Value else { Log.guard() }
      textLabel?.text = key.titlecased()
      detailTextLabel?.text = value
    }
  }

  public class DateCell: BasicCell {

    public func prepare(for model: Any?, path _: IndexPath) {
      guard case let .date(key, value)? = model as? JSON.Value else { Log.guard() }
      textLabel?.text = key.titlecased()
      detailTextLabel?.text = value.localizedString()
    }
  }

  public class ArrayCell: BasicCell {

    public func prepare(for model: Any?, path _: IndexPath) {
      guard case let .array(key, arrayValue)? = model as? JSON.Value,
            case let .dictionary(jsonArray) = arrayValue
      else { Log.guard() }

      textLabel?.text = key.titlecased()
      let formatString: String!
      if jsonArray.count == 1 {
        formatString = NSLocalizedString("%@ Item", comment: "")
      } else {
        formatString = NSLocalizedString("%@ Items", comment: "")
      }
      detailTextLabel?.text =
        .localizedStringWithFormat(
          formatString,
          jsonArray.count.integerString())
      accessoryType = .disclosureIndicator
    }
  }

  public class DictionaryCell: BasicCell {

    public func prepare(for model: Any?, path _: IndexPath) {
      guard case let .dictionary(key, jsonDictionary)? = model as? JSON.Value,
            case let .any(json) = jsonDictionary
      else { Log.guard() }
      textLabel?.text = key.titlecased()

      let formatString: String!
      if json.count == 1 {
        formatString = NSLocalizedString("%@ Detail", comment: "")
      } else {
        formatString = NSLocalizedString("%@ Details", comment: "")
      }
      detailTextLabel?.text =
        .localizedStringWithFormat(
          formatString,
          json.count.integerString())
      accessoryType = .disclosureIndicator
    }
  }

  public class AnyCell: BasicCell {

    public func prepare(for model: Any?, path _: IndexPath) {
      guard case let .any(value, key)? = model as? JSON.Value else { Log.guard() }
      textLabel?.text = key.titlecased()
      detailTextLabel?.text = value
    }
  }
}
#endif
