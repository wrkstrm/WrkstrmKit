#if canImport(UIKit)
import UIKit
import WrkstrmFoundation
import WrkstrmLog
import WrkstrmMain

extension WrkstrmMain.JSON {
  open class BasicCell: UITableViewCell, StyleableCell {
    public static var cellStyle: UITableViewCell.CellStyle = .value1

    /// UITableViewCells instantiated from a UITableView's deque mechanism instantiates classes with
    ///  the `.default` style. This override allows for a particular style to be instantiated by a
    ///  subclass through the static `cellStyle` property.
    /// - Parameter style: The default style to be ignored.
    /// - Parameter reuseIdentifier: The cellReuseIdentifier. Usually "{Class}Identifier"
    override public required init(
      style _: UITableViewCell.CellStyle,
      reuseIdentifier: String?
    ) {
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
      guard case .integer(let key, let value)? = model as? JSON.KVPair else {
        Log.kit.guard()
      }
      textLabel?.text = key.titlecased()
      detailTextLabel?.text = NumberFormatter.integer.string(for: value)
    }
  }

  public class DoubleCell: BasicCell {
    public func prepare(for model: Any?, path _: IndexPath) {
      guard case .double(let key, let value)? = model as? JSON.KVPair else {
        Log.kit.guard()
      }
      textLabel?.text = key.titlecased()
      detailTextLabel?.text = value.doubleString()
    }
  }

  public class StringCell: BasicCell {
    public func prepare(for model: Any?, path _: IndexPath) {
      guard case .string(let key, let value)? = model as? JSON.KVPair else {
        Log.kit.guard()
      }
      textLabel?.text = key.titlecased()
      detailTextLabel?.text = value
    }
  }

  public class DateCell: BasicCell {
    public func prepare(for model: Any?, path _: IndexPath) {
      guard case .date(let key, let value)? = model as? JSON.KVPair else {
        Log.kit.guard()
      }
      textLabel?.text = key.titlecased()
      detailTextLabel?.text = value.localizedString()
    }
  }

  public class ArrayCell: BasicCell {
    public func prepare(for model: Any?, path _: IndexPath) {
      guard case .array(let key, let arrayValue)? = model as? JSON.KVPair,
        case .dictionary(let jsonArray) = arrayValue
      else { Log.kit.guard() }

      textLabel?.text = key.titlecased()
      let formatString =
        (jsonArray.count == 1)
        ? NSLocalizedString("%@ Item", bundle: .main, comment: "")
        : NSLocalizedString("%@ Items", bundle: .main, comment: "")

      let count = jsonArray.count.integerString() ?? "?"
      detailTextLabel?.text =
        .localizedStringWithFormat(
          formatString,
          count,
        )
      accessoryType = .disclosureIndicator
    }
  }

  public class DictionaryCell: BasicCell {
    public func prepare(for model: Any?, path _: IndexPath) {
      guard
        case .dictionary(let key, let jsonDictionary)? = model as? JSON.KVPair,
        case .any(let json) = jsonDictionary
      else { Log.kit.guard() }
      textLabel?.text = key.titlecased()

      let formatString =
        (json.count == 1)
        ? NSLocalizedString("%@ Detail", bundle: .main, comment: "")
        : NSLocalizedString("%@ Details", bundle: .main, comment: "")
      let count = json.count.integerString() ?? "?"
      detailTextLabel?.text =
        .localizedStringWithFormat(
          formatString,
          count,
        )
      accessoryType = .disclosureIndicator
    }
  }

  public class AnyCell: BasicCell {
    public func prepare(for model: Any?, path _: IndexPath) {
      guard case .any(let value, let key)? = model as? JSON.KVPair else {
        Log.kit.guard()
      }
      textLabel?.text = key.titlecased()
      detailTextLabel?.text = value
    }
  }
}
#endif
