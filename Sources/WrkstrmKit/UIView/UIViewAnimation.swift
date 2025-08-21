#if canImport(UIKit)
import UIKit

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

  public convenience init(with options: Options, _ stage: Stage) {
    self.init(with: options, stage, next: nil)
  }

  public static func animation(
    with options: Options,
    _ stage: Stage,
    next _: UIViewAnimation? = nil,
  ) -> UIViewAnimation {
    .init(with: options, stage, next: nil)
  }
}

extension UIViewAnimation {
  public struct Options: Equatable {
    public let duration: TimeInterval

    public let delay: TimeInterval

    public let timingOptions: UIView.AnimationOptions

    public let hold: TimeInterval

    public init(
      duration: TimeInterval,
      delay: TimeInterval = 0,
      timingOptions: UIView.AnimationOptions = [],
      hold: TimeInterval = 0,
    ) {
      self.duration = duration
      self.delay = delay
      self.timingOptions = timingOptions
      self.hold = hold
    }

    public static func duration(_ duration: TimeInterval) -> Self {
      options(duration: duration)
    }

    public static func options(
      duration: TimeInterval,
      delay: TimeInterval = 0,
      timingOptions: UIView.AnimationOptions = [],
      hold: TimeInterval = 0,
    ) -> Self {
      .init(duration: duration, delay: delay, timingOptions: timingOptions, hold: hold)
    }
  }

  public struct Stage {
    public var load: (() -> Void)?

    public let perform: (() -> Void)?

    public init(load: (() -> Void)? = nil, perform: (() -> Void)?) {
      self.load = load
      self.perform = perform
    }

    public static func stage(load: (() -> Void)? = nil, perform: (() -> Void)?) -> Self {
      .init(load: load, perform: perform)
    }
  }
}

extension UIViewAnimation: Sequence {
  public func makeIterator() -> UIViewAnimationIterator {
    UIViewAnimationIterator(animation: self)
  }
}

public struct UIViewAnimationIterator: IteratorProtocol {
  public var animation: UIViewAnimation?

  public mutating func next() -> UIViewAnimation? {
    guard let next = animation else {
      return nil
    }
    animation = next.next
    return next
  }
}

@available(*, deprecated, renamed: "UIViewAnimation")
public typealias Animation = UIViewAnimation
#endif
