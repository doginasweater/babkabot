import Logging
import Vapor

@main
enum Entrypoint {
  static func main() async throws {
    let env = try Environment.detect()
    let app = Application(env)

    defer { app.shutdown() }

    do {
      try await configure(app)
    } catch {
      app.logger.report(error: error)
      throw error
    }

    try await app.execute()
  }
}
