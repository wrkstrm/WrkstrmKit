# Chainable UIView Animations in WrkstrmKit

## Problem Space

- UIKit’s `UIView.animate` and `UIViewPropertyAnimator` are powerful but can lead to:
  - Nested completion handlers for multi-stage animations.
  - Repeated configuration for timing options and durations.
  - Ad-hoc sequencing logic scattered across view controllers.
- WrkstrmKit introduces a small, chainable abstraction around `UIViewPropertyAnimator`:
  - Encodes each animation **stage** as a value (`Stage`).
  - Groups timing parameters in an `Options` struct.
  - Links stages via a `next` pointer to build chains (including loops).
  - Executes chains with a single `UIView.perform(_:)` helper.

## Core Types

### `UIViewAnimation`

```swift
public class UIViewAnimation {
  public typealias Completion = (UIViewAnimatingPosition) -> Void

  public let options: Options
  public let stage: Stage
  public var next: UIViewAnimation?

  public init(with options: Options, _ stage: Stage, next: UIViewAnimation?) {
    self.options = options
    self.stage = stage
    self.next = next
  }
}
```

- `options` holds the timing configuration.
- `stage` captures the work for this step.
- `next` links to another `UIViewAnimation`, allowing multi-stage or looping sequences.

### `Options` – Timing Configuration

```swift
extension UIViewAnimation {
  public struct Options: Equatable {
    public let duration: TimeInterval
    public let delay: TimeInterval
    public let timingOptions: UIView.AnimationOptions
    /// Optional hold after the animation before chaining to `next`.
    public let hold: TimeInterval

    public init(
      duration: TimeInterval,
      delay: TimeInterval = 0,
      timingOptions: UIView.AnimationOptions = [],
      hold: TimeInterval = 0
    ) {
      self.duration = duration
      self.delay = delay
      self.timingOptions = timingOptions
      self.hold = hold
    }
  }
}
```

- Groups duration, delay, and animation options into a single value type.
- `hold` introduces a small pause before starting the next stage in a chain.

### `Stage` – Work to Perform

```swift
extension UIViewAnimation {
  public struct Stage {
    /// Optional setup run before the animation begins.
    public var load: (() -> Void)?
    /// Work executed inside the animation block.
    public let perform: (() -> Void)?

    public init(load: (() -> Void)? = nil, perform: (() -> Void)?) {
      self.load = load
      self.perform = perform
    }
  }
}
```

- `load` runs before the animation, often for initial layout or state setup.
- `perform` runs within the animator’s animations closure, where property changes are animated.

## Executing Animations

### `UIView.perform(_:)`

WrkstrmKit adds a convenience method on `UIView` that turns a `UIViewAnimation` into a running
`UIViewPropertyAnimator` and handles chaining:

```swift
extension UIView {
  @discardableResult
  public func perform(
    _ animation: UIViewAnimation,
    completion: UIViewAnimation.Completion? = nil
  ) -> UIViewPropertyAnimator {
    let options = animation.options
    let stage = animation.stage

    stage.load?()
    layoutIfNeeded()

    let animations = { [weak self] in
      stage.perform?()
      self?.layoutIfNeeded()
    }

    let finalCompletion: UIViewAnimation.Completion = { [weak self] position in
      guard let self else { return }
      DispatchQueue.main.asyncAfter(deadline: .now() + options.hold) { [weak self] in
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
      completion: finalCompletion
    )
  }
}
```

Key points:

- `load` and `layoutIfNeeded()` run before the animation to establish a baseline layout.
- Inside `animations`, `perform` mutates view properties and `layoutIfNeeded()` animates any
  Auto Layout constraint changes.
- The completion:
  - Waits for `options.hold` on the main queue.
  - If `animation.next` exists and the view is still in a window, recursively calls `perform(next)`.
  - Otherwise, calls the user-provided completion.

This design keeps chaining logic in one place and avoids nested completion handlers in callers.

## Example: Pulsing Animation

WrkstrmKit’s `UIView+Pulse` extension demonstrates how to build reusable patterns on top of
`UIViewAnimation`:

```swift
extension UIView {
  fileprivate static let pulseDuration: TimeInterval = 2

  @discardableResult
  public func pulseView(_ pulse: Bool) -> UIViewPropertyAnimator {
    guard pulse else {
      return perform(
        UIViewAnimation.animation(
          with: .options(duration: Self.pulseDuration, timingOptions: [.beginFromCurrentState]),
          .stage { [weak self] in self?.transform = .identity }
        )
      )
    }

    let scaleFactor: CGFloat = 0.9
    let timingOptions: UIView.AnimationOptions = [
      .curveEaseInOut,
      .allowUserInteraction,
      .beginFromCurrentState,
    ]

    let start = UIViewAnimation(
      with: .options(duration: Self.pulseDuration, timingOptions: timingOptions),
      .stage { [weak self] in
        guard let self else { return }
        transform = CGAffineTransform.identity.scaledBy(x: scaleFactor, y: scaleFactor)
      }
    )

    let next = UIViewAnimation(
      with: .options(duration: Self.pulseDuration, timingOptions: timingOptions),
      .stage { [weak self] in self?.transform = .identity },
      next: start
    )
    start.next = next

    return perform(start)
  }
}
```

Behavior:

- First stage scales the view down slightly.
- Second stage returns it to identity.
- `start.next = next` and `next.next = start` create a loop; `perform(start)` produces a continuous
  pulse until the view leaves the window or you stop it.

## Concurrency and Sequencing Considerations

- `UIViewPropertyAnimator` runs on the main run loop; `DispatchQueue.main.asyncAfter` is used to
  sequence stages with an optional hold between them.
- By centralizing chaining and timing logic in `UIView.perform(_:)`, higher-level code:
  - Remains focused on describing stages.
  - Avoids deeply nested completion handlers.
  - Gains a consistent way to stop or inspect animations (via the returned animator).

In interviews, you can describe this as:

- A small, composable “animation DSL” on top of UIKit:
  - Value types (`Options`, `Stage`) capture configuration and behavior.
  - A reference graph (`UIViewAnimation` + `next`) expresses sequencing.
  - A single executor (`UIView.perform(_:)`) drives the whole chain on the main thread.
