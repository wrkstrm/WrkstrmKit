#if canImport(SwiftUI)
  import SwiftUI

  extension PreviewDevice: @retroactive Equatable {}

  extension PreviewDevice: @retroactive Hashable {
    public static let iPhoneSE: PreviewDevice = .init(rawValue: "iPhone SE")

    public static let iPhoneSXMax: PreviewDevice = .init(rawValue: "iPhone XS Max")
  }
#endif
