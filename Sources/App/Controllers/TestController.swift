import Fluent
import Vapor

struct TestController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let debug = routes.grouped("debug")

    debug.get("tags", use: getTags)
    debug.get("links", use: getLinks)
  }

  func getTags(req: Request) async throws -> [Tag] {
    try await Tag.query(on: req.db).all()
  }

  func getLinks(req: Request) async throws -> [Link] {
    try await Link.query(on: req.db).all()
  }
}
