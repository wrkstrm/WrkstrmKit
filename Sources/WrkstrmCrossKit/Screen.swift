#if !canImport(WatchKit)
#if canImport(UIKit)
import UIKit

public typealias Screen = UIScreen
#elseif os(OSX)
import Cocoa

public typealias Screen = NSScreen
#endif

public extension Screen {

  static var hairlineWidth: CGFloat {
#if canImport(UIKit)
    return 1 / Screen.main.scale
#elseif os(OSX)
    return 1 / (Screen.main?.backingScaleFactor ?? 1)
#endif
  }
}
#endif // !canImport(WatchKit)
