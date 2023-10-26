#if canImport(UIKit)
import UIKit
import WrkstrmFoundation

public extension UIView {

  static let pulseDuration: TimeInterval = 2

  @discardableResult
  func pulseView(_ pulse: Bool) -> UIViewPropertyAnimator {
    pulseView(pulse, delay: 0.0)
  }

  @discardableResult
  func pulseView(_ pulse: Bool, delay _: CGFloat) -> UIViewPropertyAnimator {
    if pulse {
      let scaleFactor: CGFloat = 0.9
      let timingOptions: UIView.AnimationOptions = [
        .curveEaseInOut,
        .allowUserInteraction,
        .beginFromCurrentState,
      ]
      let start = Animation(
        with: .options(duration: Self.pulseDuration, timingOptions: timingOptions),
        .stage { [weak self] in guard let self = self else { return }
          self.transform = CGAffineTransform.identity.scaledBy(
            x: scaleFactor,
            y: scaleFactor)
        })

      let next = Animation(
        with: .options(duration: Self.pulseDuration, timingOptions: timingOptions),
        .stage { [weak self] in self?.transform = .identity },
        next: start)
      start.next = next
      return perform(start)
    } else {
      return perform(
        .animation(
          with: .options(duration: Self.pulseDuration, timingOptions: [.beginFromCurrentState]),
          .stage { [weak self] in self?.transform = .identity }))
    }
  }
}
#endif
