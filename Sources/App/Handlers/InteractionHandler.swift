import AsyncHTTPClient
import DiscordBM
import Foundation
import Logging

struct InteractionHandler {
  var logger = Logger(label: String(describing: InteractionHandler.self))
  var discordService: DiscordService { .shared }

  let event: Interaction
  let client: HTTPClient

  func handle() async {
    guard case let .applicationCommand(data) = event.data else {
      logger.error("Unrecognized command")
      return await sendUnknownCommandFailure()
    }

    switch CommandKind(name: data.name) {
    case .define:
      await DefineHandler(event: event, data: data, client: client).handle()
    case .presence:
      await PresenceHandler(event: event, data: data, client: client).handle()
    case .sunny:
      await SunnyHandler(event: event, data: data, client: client).handle()
    case .link:
      await LinkHandler(event: event, data: data, client: client).handle()
    default:
      logger.error("Unrecognized command")
      return await sendUnknownCommandFailure()
    }
  }

  private func sendUnknownCommandFailure() async {
    await discordService.respondToInteraction(
      id: event.id,
      token: event.token,
      payload: .init(
        type: .channelMessageWithSource,
        data: .init(
          embeds: [
            .init(description: "Failed to resolve the interaction name :(")
          ],
          flags: [.ephemeral]
        )
      )
    )
  }
}
