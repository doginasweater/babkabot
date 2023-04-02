import DiscordBM
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

    // DiscordGlobalConfiguration.logManager = DiscordLogManager(
    //   httpClient: HTTP_CLIENT_YOU_MADE_IN_PREVIOUS_STEPS,
    //   configuration: .init(
    //       aliveNotice: .init(
    //         address: try .url(WEBHOOK_URL),
    //         /// If nil, DiscordLogger will only send 1 "I'm alive" notice, on boot.
    //         /// If not nil, it will send a "I'm alive" notice every this-amount too.
    //         interval: nil,
    //         message: "I'm Alive! :)",
    //         color: .blue,
    //       ),
    //       extraMetadata: [.warning, .error, .critical],
    //       disabledLogLevels: [.debug, .trace],
    //       disabledInDebug: true
    //   )
    // )

    return bot
}

func configureDatabase(_ app: Application) async throws {
  switch app.environment {
    case .production:
      app.databases.use(.postgres(
          hostname: Environment.get("DATABASE_HOST") ?? "localhost",
          port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
          username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
          password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
          database: Environment.get("DATABASE_NAME") ?? "vapor_database"
      ), as: .psql)
    default:
      app.databases.use(.sqlite(.file("babka.db")), as: .sqlite)
  }

  app.migrations.add(Link.Migration())
  app.migrations.add(Tag.Migration())
  app.migrations.add(LinkTag.Migration())

  try await app.autoMigrate()
}

public func configure(_ app: Application) async throws {
    try await configureDatabase(app)

    let bot = configureDiscord(app)

    await DiscordService.shared.initialize(client: bot.client)

    await bot.addEventHandler { event in
      EventHandler(
        event: event,
        client: app.http.client.shared
      ).handle()
    }

    await bot.connect()

    await CommandsManager().registerCommands()
}
