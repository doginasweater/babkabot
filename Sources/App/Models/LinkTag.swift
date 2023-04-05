import Fluent
import Vapor

final class LinkTag: Model, Content {
  static let schema = "linktag"

  @ID(key: .id)
  var id: UUID?

  @Parent(key: "link_id")
  var link: Link

  @Parent(key: "tag_id")
  var tag: Tag

  init() {}

  init(
    id: UUID? = nil,
    link: Link,
    tag: Tag
  ) throws {
    self.id = id
    self.$link.id = try link.requireID()
    self.$tag.id = try tag.requireID()
  }
}

extension LinkTag {
  struct Migration: AsyncMigration {
    func prepare(on database: Database) async throws {
      try await database.schema(LinkTag.schema)
        .id()
        .field("link_id", .uuid, .references(Link.schema, "id"))
        .field("tag_id", .uuid, .references(Tag.schema, "id"))
        .unique(on: "link_id", "tag_id")
        .create()
    }

    func revert(on database: Database) async throws {
      try await database.schema(LinkTag.schema).delete()
    }
  }
}
