#if canImport(UIKit)
  import UIKit

  extension CGFloat {
    static let minAlphaForTouchInput: CGFloat = 0.010_000_001
  }

  extension UIView {
    @discardableResult
    public func perform(
      _ animation: Animation,
      completion: Animation.Completion? = nil,
    ) -> UIViewPropertyAnimator {
      let options = animation.options
      let stage = animation.stage

      stage.load?()
      layoutIfNeeded()

      let animations = { [weak self] in
        stage.perform?()
        self?.layoutIfNeeded()
      }

      let finalCompletion: Animation.Completion = { [weak self] position in
        guard let self else { return }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + options.hold) { [weak self] in
          guard let self else { return }
          if let next = animation.next, window != nil {
            perform(next, completion: completion)
          } else {
            completion?(position)
          }
        }
      }

      return UIViewPropertyAnimator.runningPropertyAnimator(
        withDuration: options.duration,
        delay: options.delay,
        options: options.timingOptions,
        animations: animations,
        completion: finalCompletion,
      )
    }

    public func hide(_ views: [UIView]) {
      views.forEach { $0.alpha = .minAlphaForTouchInput }
    }

    public func show(_ views: [UIView]) {
      views.forEach { $0.alpha = 1 }
    }
  }
#endif
