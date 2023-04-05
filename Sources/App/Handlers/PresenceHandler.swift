import AsyncHTTPClient
import DiscordBM
import Foundation
import Logging

struct PresenceHandler {
  var logger = Logger(label: "PresenceHandler")
  var discordService: DiscordService { .shared }
  var gatewayService: GatewayService { .shared }

  let event: Interaction
  let data: Interaction.ApplicationCommand

  init(event: Interaction, data: Interaction.ApplicationCommand) {
    self.event = event
    self.data = data
  }

  func handle() async {
    let options = data.options ?? []

    if options.isEmpty {
      logger.error("Options is empty")
      await sendFailure(message: "What is the bot playing?")
    }

    guard
      let activity = options.first(where: { $0.name == "activity" })?.value?.asString,
      let type = options.first(where: { $0.name == "type" })?.value?.asString
    else {
      await sendFailure(message: "What is the bot playing?")
      return
    }

    await gatewayService.updatePresence(name: activity, type: toKind(from: type), status: .online)
    await discordService.respondToInteraction(
      id: event.id,
      token: event.token,
      payload: .init(
        type: .channelMessageWithSource,
        data: .init(
          content: "Updated bot presence!"
        )
      )
    )
  }

  private func toKind(from: String) -> Gateway.Activity.Kind {
    switch from {
    case "game": return .game
    case "streaming": return .streaming
    case "listening": return .listening
    case "watching": return .watching
    case "custom": return .custom
    case "competing": return .competing
    default: return .game
    }
  }

  private func sendFailure(message: String) async {
    await discordService.respondToInteraction(
      id: event.id,
      token: event.token,
      payload: .init(
        type: .channelMessageWithSource,
        data: .init(
          embeds: [
            .init(description: message)
          ]
        )
      )
    )
  }
}
