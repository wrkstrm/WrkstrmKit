#if canImport(UIKit) || os(macOS)
import Testing
@testable import WrkstrmCrossKit
#if canImport(UIKit)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Expectation: `cache(_:)` stores a constraint's original constant so
/// `reset(_:)` can restore it after temporary modifications. Encountered
/// when constraints are adjusted for animations or state changes.
@MainActor
@Test
func testCacheAndResetRestoreConstant() {
  let view = PlatformView()
  let constraint = view.widthAnchor.constraint(equalToConstant: 100)
  constraint.isActive = true
  view.cache(constraint)
  constraint.constant = 200
  view.reset(constraint)
  #expect(constraint.constant == 100)
}

/// Expectation: `constrainEdges(to:)` pins a child view to all edges of
/// its container. Encountered when a subview should match the container's
/// size and position.
@MainActor
@Test
func testConstrainEdgesProducesExpectedConstraints() {
  let container = PlatformView()
  let child = PlatformView()
  child.translatesAutoresizingMaskIntoConstraints = false
  container.addSubview(child)
  child.constrainEdges(to: container)
  let attributes: [NSLayoutConstraint.Attribute] = [.top, .leading, .trailing, .bottom]
  for attribute in attributes {
    #expect(
      container.constraints.contains { constraint in
        constraint.firstItem === child && constraint.secondItem === container
          && constraint.firstAttribute == attribute && constraint.secondAttribute == attribute
      })
  }
}

/// Expectation: `constrainToCenter(in:)` aligns a child view's center with
/// its container. Encountered when a subview needs to remain centered
/// within a parent view.
@MainActor
@Test
func testConstrainToCenterProducesExpectedConstraints() {
  let container = PlatformView()
  let child = PlatformView()
  child.translatesAutoresizingMaskIntoConstraints = false
  container.addSubview(child)
  child.constrainToCenter(in: container)
  let attributes: [NSLayoutConstraint.Attribute] = [.centerX, .centerY]
  for attribute in attributes {
    #expect(
      container.constraints.contains { constraint in
        constraint.firstItem === child && constraint.secondItem === container
          && constraint.firstAttribute == attribute && constraint.secondAttribute == attribute
      })
  }
}
#endif
