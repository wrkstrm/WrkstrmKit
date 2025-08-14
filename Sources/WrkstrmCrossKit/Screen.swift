#if canImport(UIKit) || os(OSX)
  #if canImport(UIKit)
    import UIKit

    public typealias Screen = UIScreen
  #elseif os(OSX)
    import Cocoa

    public typealias Screen = NSScreen
  #endif

  extension Screen {
    public static var hairlineWidth: CGFloat {
      #if canImport(UIKit)
        return 1 / Screen.main.scale
      #elseif os(OSX)
        return 1 / (Screen.main?.backingScaleFactor ?? 1)
      #endif
    }
  }
#endif  // canImport(UIKit) || os(OSX)
