import Fluent
import Vapor

final class Link: Model, Content {
  static let schema = "links"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "title")
  var title: String

  @Field(key: "url")
  var url: String

  @Field(key: "created_by")
  var createdBy: String

  @Field(key: "from_server")
  var fromServer: String

  @Field(key: "from_channel")
  var fromChannel: String

  @Siblings(through: LinkTag.self, from: \.$link, to: \.$tag)
  var tags: [Tag]

  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?

  @Timestamp(key: "updated_at", on: .update)
  var updatedAt: Date?

  @Timestamp(key: "deleted_at", on: .delete)
  var deletedAt: Date?

  init() {}

  init(
    id: UUID? = nil,
    title: String,
    url: String,
    createdBy: String,
    fromServer: String,
    fromChannel: String,
    createdAt: Date? = nil
  ) {
    self.id = id
    self.title = title
    self.url = url
    self.createdBy = createdBy
    self.fromServer = fromServer
    self.fromChannel = fromChannel
    self.createdAt = createdAt
  }
}

extension Link {
  struct Migration: AsyncMigration {
    func prepare(on database: Database) async throws {
      try await database.schema(Link.schema)
        .id()
        .field("title", .string, .required)
        .field("url", .string, .required)
        .field("created_by", .string, .required)
        .field("from_server", .string, .required)
        .field("from_channel", .string, .required)
        .field("created_at", .datetime)
        .field("updated_at", .datetime)
        .field("deleted_at", .datetime)
        .create()
    }

    func revert(on database: Database) async throws {
      try await database.schema(Link.schema).delete()
    }
  }
}
