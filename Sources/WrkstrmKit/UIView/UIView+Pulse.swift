#if canImport(UIKit)
  import UIKit
  import WrkstrmFoundation

  extension UIView {
    fileprivate static let pulseDuration: TimeInterval = 2

    @discardableResult
    public func pulseView(_ pulse: Bool) -> UIViewPropertyAnimator {
      pulseView(pulse, delay: 0.0)
    }

    @discardableResult
    public func pulseView(_ pulse: Bool, delay _: CGFloat) -> UIViewPropertyAnimator {
      guard pulse else {
        return perform(
          .animation(
            with: .options(duration: Self.pulseDuration, timingOptions: [.beginFromCurrentState]),
            .stage { [weak self] in self?.transform = .identity },
          ))
      }
      let scaleFactor: CGFloat = 0.9
      let timingOptions: UIView.AnimationOptions = [
        .curveEaseInOut,
        .allowUserInteraction,
        .beginFromCurrentState,
      ]
      let start: Animation = .init(
        with: .options(duration: Self.pulseDuration, timingOptions: timingOptions),
        .stage { [weak self] in
          guard let self else { return }
          transform = CGAffineTransform.identity.scaledBy(
            x: scaleFactor,
            y: scaleFactor,
          )
        },
      )

      let next: Animation = .init(
        with: .options(duration: Self.pulseDuration, timingOptions: timingOptions),
        .stage { [weak self] in self?.transform = .identity },
        next: start,
      )
      start.next = next
      return perform(start)
    }
  }
#endif
