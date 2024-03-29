import Fluent
import Vapor

actor Repo {
  private let db: Database

  init(db: Database) {
    self.db = db
  }

  func getLinks(filter: Privacy, id: String) async throws -> [Link] {
    switch filter {
    case .personal:
      return try await Link.query(on: db)
        .with(\.$tags)
        .filter(\.$createdBy == id)
        .all()
    case .serverOnly:
      return try await Link.query(on: db)
        .with(\.$tags)
        .filter(\.$fromServer == id)
        .all()
    case .global:
      return try await Link.query(on: db).with(\.$tags).all()
    }
  }

  func saveLink(link: Link, tags: [Tag]) async throws {
    try await link.save(on: db)

    for tag in tags {
      try await tag.save(on: db)
      try await link.$tags.attach(tag, method: .ifNotExists, on: db)
    }
  }

  func getTags(names: [String], server: String) async throws -> [Tag] {
    try await Tag.query(on: db)
      .filter(\.$fromServer == server)
      .filter(\.$name ~~ names)
      .all()
  }
}
