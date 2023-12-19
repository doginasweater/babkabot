import DiscordBM
import DiscordLogger
import Fluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Logging
import Vapor

public func configureDiscord(_ app: Application) async -> BotGatewayManager {
  guard
    let token = Environment.get("DISCORD_API_TOKEN"),
    !token.isEmpty
  else {
    fatalError("Unable to find bot token")
  }

  let bot = await BotGatewayManager(
    eventLoopGroup: app.eventLoopGroup,
    httpClient: app.http.client.shared,
    token: token,
    presence: .init(
      activities: [.init(name: "Cooking by the book", type: .game)],
      status: .online,
      afk: false
    ),
    intents: [.guildMessages, .guildMessageReactions, .messageContent]
  )

  return bot
}

/// Configure the logger!
///
/// - Parameter app: main app stuff
public func configureLogger(_ app: Application) async throws {
  guard
    let webhookURL = Environment.get("LOG_URL"),
    let meId = Environment.get("ME_ID"),
    let warningRole = Environment.get("WARNING_ROLE"),
    let errorRole = Environment.get("ERROR_ROLE"),
    let criticalRole = Environment.get("CRITICAL_ROLE")
  else {
    print(
      "Unable to load environment variables required for discord logging. Falling back to vapor logging."
    )
    app.logger.warning(
      "Unable to load environment variables required for discord logging. Falling back to vapor logging."
    )
    return
  }

  DiscordGlobalConfiguration.logManager = await DiscordLogManager(
    httpClient: app.http.client.shared,
    configuration: .init(
      aliveNotice: .init(
        address: try .url(webhookURL),
        interval: nil,
        message: "Good morning!",
        color: .blue,
        initialNoticeMention: .user(.init(meId))
      ),
      mentions: [
        .warning: .role(.init(warningRole)),
        .error: .role(.init(errorRole)),
        .critical: .role(.init(criticalRole)),
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

/// Configure the database for the app
///
///  - Parameters:
///    - app: The main application object
///  - Returns: void
public func configureDatabase(_ app: Application) async throws {
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
  app.migrations.add(Privacy.Migration())

  try await app.autoMigrate()
}

/// Main configuration function
///
/// - Parameter app: the main application object
public func configure(_ app: Application) async throws {
  try await configureLogger(app)
  try await configureDatabase(app)

  let bot = await configureDiscord(app)

  let cache = await DiscordCache(
    gatewayManager: bot,
    intents: [.guilds, .guildMembers],
    requestAllMembers: .enabled
  )

  let services = Context.Services(
    discordSvc: DiscordService(client: bot.client, cache: cache),
    gatewaySvc: GatewayService(bot: bot),
    httpClient: app.http.client.shared,
    repo: Repo(db: app.db)
  )

  let ctx = Context(services: services)

  await bot.connect()

  try await CommandManager(client: bot.client).registerCommands()

  for await event in await bot.events {
    EventHandler(event: event, ctx: ctx).handle()
  }

  if app.environment == .development {
    try app.register(collection: TestController())
  }

  print("We're connected!")
}
