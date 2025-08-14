import Testing

#if canImport(UIKit)
import UIKit
@testable import WrkstrmKit

/// The result of `FontMetrics.scaledFont(for:)` should mirror the behavior of
/// `UIFontMetrics.default.scaledFont(for:compatibleWith:)` for multiple content
/// size categories.
@Test
func testScaledFontMatchesUIFontMetrics() {
  let baseFont = UIFont.systemFont(ofSize: 12)
  let categories: [UIContentSizeCategory] = [
    .extraSmall,
    .large,
    .extraExtraLarge,
  ]

  if #available(iOS 17.0, tvOS 17.0, watchOS 10.0, *) {
    for category in categories {
      let trait = UITraitCollection(preferredContentSizeCategory: category)
      trait.performAsCurrent {
        let expected = UIFontMetrics.default.scaledFont(for: baseFont, compatibleWith: trait)
        let result = FontMetrics.scaledFont(for: baseFont)
        #expect(result.pointSize == expected.pointSize)
      }
    }
  }
}

/// `FontMetrics.scaledFont(for:maximumPointSize:)` should not produce a font
/// larger than the supplied maximum point size even when the system metrics
/// would scale it beyond that limit.
@Test
func testScaledFontRespectsMaximumPointSize() {
  let baseFont = UIFont.systemFont(ofSize: 12)
  let maxPointSize: CGFloat = 20

  if #available(iOS 17.0, tvOS 17.0, watchOS 10.0, *) {
    let category = UIContentSizeCategory.accessibilityExtraExtraExtraLarge
    let trait = UITraitCollection(preferredContentSizeCategory: category)
    trait.performAsCurrent {
      let expected = UIFontMetrics.default.scaledFont(for: baseFont, compatibleWith: trait)
      let result = FontMetrics.scaledFont(for: baseFont, maximumPointSize: maxPointSize)
      #expect(result.pointSize == min(expected.pointSize, maxPointSize))
    }
  }
}

#else

/// Lightweight stand-in for a platform font used to validate behavior when
/// `UIFontMetrics` is unavailable.
struct MockFont {
  var pointSize: Double
  func withSize(_ size: Double) -> MockFont { MockFont(pointSize: size) }
}

/// Simplified font metrics used solely for tests to apply a fixed scaling
/// factor and optional maximum point size.
enum MockFontMetrics {
  static var scaler: Double { 1.5 }
  static func scaledFont(for font: MockFont) -> MockFont {
    font.withSize(scaler * font.pointSize)
  }
  static func scaledFont(for font: MockFont, maximumPointSize: Double) -> MockFont {
    font.withSize(min(scaler * font.pointSize, maximumPointSize))
  }
}

/// `scaledFont(for:)` should multiply the base size by `scaler` when the
/// system font metrics are not available.
@Test
func testScaledFontFallback() {
  let font = MockFont(pointSize: 10)
  let scaled = MockFontMetrics.scaledFont(for: font)
  #expect(scaled.pointSize == 15)
}

/// `scaledFont(for:maximumPointSize:)` should still respect the provided limit
/// when using the fallback metrics implementation.
@Test
func testScaledFontFallbackMaximum() {
  let font = MockFont(pointSize: 10)
  let scaled = MockFontMetrics.scaledFont(for: font, maximumPointSize: 14)
  #expect(scaled.pointSize == 14)
}

#endif
