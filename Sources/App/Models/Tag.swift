import Fluent
import Vapor

final class Tag: Model, Content {
  static let schema = "tags"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "name")
  var name: String

  @Field(key: "from_server")
  var fromServer: String

  @OptionalField(key: "from_channel")
  var fromChannel: String?

  @Enum(key: "privacy")
  var privacy: Privacy

  @Siblings(through: LinkTag.self, from: \.$tag, to: \.$link)
  var links: [Link]

  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?

  @Timestamp(key: "updated_at", on: .update)
  var updatedAt: Date?

  @Timestamp(key: "deleted_at", on: .delete)
  var deletedAt: Date?

  init() {}

  init(
    id: UUID? = nil,
    name: String,
    fromServer: String,
    fromChannel: String? = nil,
    createdAt: Date? = nil,
    privacy: Privacy = .serverOnly
  ) {
    self.id = id
    self.name = name
    self.fromServer = fromServer
    self.fromChannel = fromChannel
    self.createdAt = createdAt
    self.privacy = privacy
  }
}

extension Tag {
  struct Migration: AsyncMigration {
    func prepare(on database: Database) async throws {
      try await database.schema(Tag.schema)
        .id()
        .field("name", .string, .required)
        .field("from_server", .string, .required)
        .field("from_channel", .string)
        .field("created_at", .datetime)
        .field("updated_at", .datetime)
        .field("deleted_at", .datetime)
        .create()
    }

    func revert(on database: Database) async throws {
      try await database.schema(Tag.schema).delete()
    }
  }
}
