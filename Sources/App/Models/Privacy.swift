import Fluent
import Vapor

enum Privacy: String, Codable {
  case global
  case serverOnly
  case personal
}

extension Privacy {
  struct Migration: AsyncMigration {
    func prepare(on database: Database) async throws {
      let privacyEnum = try await database.enum("privacy")
        .case("global")
        .case("serverOnly")
        .case("personal")
        .create()

      try await database.schema(Link.schema)
        .field("privacy", privacyEnum, .required)
        .update()

      try await database.schema(Tag.schema)
        .field("privacy", privacyEnum, .required)
        .update()
    }

    func revert(on database: Database) async throws {
      try await database.schema(Link.schema)
        .deleteField("privacy")
        .update()

      try await database.schema(Tag.schema)
        .deleteField("privacy")
        .update()

      try await database.enum("privacy").delete()
    }
  }
}
