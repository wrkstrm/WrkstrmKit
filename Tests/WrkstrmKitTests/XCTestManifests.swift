import XCTest

#if !canImport(ObjectiveC)
  public func allTests() -> [XCTestCaseEntry] {
    [testCase(WrkstrmKitTests.allTests)]
  }
#endif
