import WrkstrmLog

extension Log {
  @MainActor
  static let kit: Log = {
    var log = Log(system: "wrkstrm", category: "kit")
    log.maxFunctionLength = 25
    return log
  }()
}
