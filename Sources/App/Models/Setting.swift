import Fluent
import Vapor

enum SettingKey: String, Codable {
  case playing
}

final class Setting: Model, Content {
  static let schema = "settings"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "server_id")
  var serverId: String

  @Enum(key: "setting_key")
  var settingKey: SettingKey

  @Field(key: "setting_value")
  var settingValue: String

  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?

  @Timestamp(key: "updated_at", on: .update)
  var updatedAt: Date?

  @Timestamp(key: "deleted_at", on: .delete)
  var deletedAt: Date?

  init() {}

  init(
    id: UUID? = nil,
    serverId: String,
    settingKey: SettingKey,
    value: String
  ) {
    self.id = id
    self.serverId = serverId
    self.settingKey = settingKey
    self.settingValue = value
  }
}

extension Setting {
  struct Migration: AsyncMigration {
    func prepare(on database: Database) async throws {
      let settingKeys = try await database.enum("setting_keys")
        .case("playing")
        .create()

      try await database.schema(Setting.schema)
        .id()
        .field("server_id", .string, .required)
        .field("setting_key", settingKeys, .required)
        .field("setting_value", .string, .required)
        .field("created_at", .datetime)
        .field("updated_at", .datetime)
        .field("deleted_at", .datetime)
        .create()
    }

    func revert(on database: Database) async throws {
      try await database.schema("setting_key").delete()
      try await database.schema("settings").delete()
    }
  }
}
