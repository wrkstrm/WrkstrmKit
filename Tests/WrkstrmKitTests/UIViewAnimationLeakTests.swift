#if canImport(UIKit)
import Testing
@testable import WrkstrmKit
import UIKit

/// Verifies the current graph-based UIViewAnimation design creates a retain cycle
/// when animations are linked in a loop (start.next = next; next.next = start).
///
/// This test intentionally documents the existing bug so we have a concrete
/// before/after signal when refactoring to a sequence-based model.
@Test
func uiviewAnimationRetainCycleExistsForLoop() {
  weak var weakStart: UIViewAnimation?

  do {
    let options = UIViewAnimation.Options(duration: 0.1)
    let stage = UIViewAnimation.Stage(perform: {})

    let start = UIViewAnimation(with: options, stage)
    let next = UIViewAnimation(with: options, stage, next: start)
    start.next = next

    weakStart = start
  }

  // Because start and next retain each other (start ↔ next) and nothing
  // outside the cycle holds a strong reference, ARC should be able to
  // deallocate both if there were no cycle. In the current design, the
  // mutual strong references keep them alive, so the weak reference remains
  // non-nil, demonstrating the leak.
  #expect(weakStart != nil)
}
#endif

