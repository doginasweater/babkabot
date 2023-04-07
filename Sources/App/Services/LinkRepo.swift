import Fluent
import Vapor

actor LinkRepo {
  private var db: Database!

  private init() {}

  static let shared: LinkRepo = LinkRepo()

  func initialize(db: Database) {
    self.db = db
  }

  func getLinks(filter: Privacy, id: String) async throws -> [Link] {
    switch filter {
    case .personal:
      return try await Link.query(on: db)
        .filter(\.$createdBy == id)
        .all()
    case .serverOnly:
      return try await Link.query(on: db)
        .filter(\.$fromServer == id)
        .all()
    case .global:
      return try await Link.query(on: db).all()
    }
  }

  func saveLink(link: Link) async throws {
    try await link.save(on: db)
  }
}
