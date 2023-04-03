import DiscordBM
import DiscordLogger
import Fluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Vapor

func configureDiscord(_ app: Application) -> BotGatewayManager {
  guard let token = Environment.get("DISCORD_API_TOKEN") else {
    fatalError("Unable to find bot token")
  }

  guard let appId = Environment.get("DISCORD_CLIENT_ID") else {
    fatalError("Unable to find client ID")
  }

  let bot = BotGatewayManager(
    eventLoopGroup: app.eventLoopGroup,
    httpClient: app.http.client.shared,
    token: token,
    appId: appId,
    presence: .init(
      activities: [.init(name: "Cooking by the book", type: .game)],
      status: .online,
      afk: false
    ),
    intents: []
  )

  return bot
}

func configureLogger(_ app: Application) async throws {
  guard
    let webhookURL = Environment.get("LOG_URL"),
    let meId = Environment.get("ME_ID"),
    let warningRole = Environment.get("WARNING_ROLE"),
    let errorRole = Environment.get("ERROR_ROLE"),
    let criticalRole = Environment.get("CRITICAL_ROLE")
  else {
    app.logger.warning("Unable to load environment variables required for discord logging. Falling back to vapor logging.")
    return
  }

  DiscordGlobalConfiguration.logManager = DiscordLogManager(
    httpClient: app.http.client.shared,
    configuration: .init(
      aliveNotice: .init(
        address: try .url(webhookURL),
        interval: nil,
        message: "Good morning!",
        color: .blue,
        initialNoticeMention: .user(meId)
      ),
      mentions: [
        .warning: .role(warningRole),
        .error: .role(errorRole),
        .critical: .role(criticalRole)
      ],
      extraMetadata: [.warning, .error, .critical],
      disabledLogLevels: [.debug, .trace],
      disabledInDebug: true
    )
  )

  await LoggingSystem.bootstrapWithDiscordLogger(
    address: try .url(webhookURL),
    makeMainLogHandler: StreamLogHandler.standardOutput(label:metadataProvider:)
  )
}

func configureDatabase(_ app: Application) async throws {
  switch app.environment {
    case .production:
      guard let databaseURL = Environment.get("DATABASE_URL") else {
        app.logger.error("Unable to find database url!")
        return app.shutdown()
      }

      try app.databases.use(.postgres(url: databaseURL), as: .psql)
    default:
      app.databases.use(.sqlite(.file("babka.db")), as: .sqlite)
  }

  app.migrations.add(Link.Migration())
  app.migrations.add(Tag.Migration())
  app.migrations.add(LinkTag.Migration())
  app.migrations.add(Setting.Migration())

  try await app.autoMigrate()
}

public func configure(_ app: Application) async throws {
  try await configureLogger(app)
  try await configureDatabase(app)

  let bot = configureDiscord(app)

  await DiscordService.shared.initialize(client: bot.client)
  await GatewayService.shared.initialize(bot: bot)

  await bot.addEventHandler { event in
    EventHandler(
      event: event,
      client: app.http.client.shared
    ).handle()
  }

  await bot.connect()

  await CommandsManager().registerCommands()
}
