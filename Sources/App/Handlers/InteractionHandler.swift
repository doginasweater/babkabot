import AsyncHTTPClient
import DiscordBM
import Foundation
import Logging

struct InteractionHandler {
  var logger = Logger(label: String(describing: InteractionHandler.self))
  var discordService: DiscordService { .shared }

  let client: HTTPClient
  let event: Interaction

  init(event: Interaction, client: HTTPClient) {
    self.event = event
    self.client = client
  }

  func handle() async {
    guard case let .applicationCommand(data) = event.data else {
      logger.error("Unrecognized command")
      return await sendUnknownCommandFailure()
    }

    switch CommandKind(name: data.name) {
    case .define:
      await DefineHandler(event: event, client: client, data: data).handle()
    case .presence:
      await PresenceHandler(event: event, data: data).handle()
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
