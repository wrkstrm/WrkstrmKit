#if canImport(QuartzCore)
import QuartzCore

extension CAGradientLayer {
  typealias Positions = (start: CGPoint, end: CGPoint)

  enum Direction: CaseIterable {
    case leftRight

    case rightLeft

    case topBottom

    case bottomTop

    case topLeftBottomRight

    case bottomRightTopLeft

    case topRightBottomLeft

    case bottomLeftTopRight

    var position: Positions {
      switch self {
      case .leftRight:
        (start: .init(x: 0, y: 0.5), end: .init(x: 1, y: 0.5))

      case .rightLeft:
        (start: .init(x: 1, y: 0.5), end: .init(x: 0, y: 0.5))

      case .topBottom:
        (start: .init(x: 0.5, y: 0), end: .init(x: 0.5, y: 1))

      case .bottomTop:
        (start: .init(x: 0.5, y: 1), end: .init(x: 0.5, y: 0))

      case .topLeftBottomRight:
        (start: .init(x: 0, y: 0), end: .init(x: 1, y: 1))

      case .bottomRightTopLeft:
        (start: .init(x: 1, y: 1), end: .init(x: 0, y: 0))

      case .topRightBottomLeft:
        (start: .init(x: 1, y: 0), end: .init(x: 0, y: 1))

      case .bottomLeftTopRight:
        (start: .init(x: 0, y: 1), end: .init(x: 1, y: 0))
      }
    }
  }

  var direction: Direction? {
    get {
      Direction.allCases.first { $0.position == (start: startPoint, end: endPoint) }
    }
    set {
      startPoint = newValue?.position.start ?? CGPoint(x: 0.5, y: 0)
      endPoint = newValue?.position.end ?? CGPoint(x: 0.5, y: 1)
    }
  }
}
#endif  // canImport(QuartzCore)
