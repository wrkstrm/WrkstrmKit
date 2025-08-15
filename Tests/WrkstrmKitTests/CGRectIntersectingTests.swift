import Testing

#if canImport(CoreGraphics)
import CoreGraphics
@testable import WrkstrmKit

@Test
func testPointIntersection() {
  let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
  #expect(rect.isIntersecting(with: CGPoint(x: 5, y: 5)))
  #expect(!rect.isIntersecting(with: CGPoint(x: 20, y: 20)))
}

@Test
func testRectIntersection() {
  let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
  #expect(rect.isIntersecting(with: CGRect(x: 5, y: 5, width: 5, height: 5)))
  #expect(!rect.isIntersecting(with: CGRect(x: 20, y: 20, width: 5, height: 5)))
}
#endif
