import Testing

@testable import WrkstrmKit

#if canImport(UIKit)
import UIKit

/// Verifies that `throw(message:)` produces a `String` error carrying the supplied message.
@Test("throw(message:) surfaces the provided message")
func throwMessageThrowsString() {
  let controller = UIViewController()

  // Attempt the throw to capture the error for assertion.
  let error = #expect(throws: String.self) {
    try controller.throw(message: "Test message") as UIViewController
  }

  // The thrown string should match the message we passed in.
  #expect(error == "Test message")
}
#endif
