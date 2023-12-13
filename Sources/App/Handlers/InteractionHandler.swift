import AsyncHTTPClient
import DiscordBM
import Foundation
import Logging

struct InteractionHandler {
  var logger = Logger(label: String(describing: InteractionHandler.self))

  let event: Interaction
  let ctx: Context

  func handle() async {
    // switch event.data {
    // case let .applicationCommand(data) where event.type == .applicationCommand:
    //   guard let command = SlashCommand(rawValue: data.name) else {
    //     logger.error("Unrecognized command")
    //   }
    // }
    guard case let .applicationCommand(data) = event.data else {
      logger.error("Unrecognized command")
      return await sendUnknownCommandFailure()
    }

    switch SlashCommand(rawValue: data.name) {
    case .define:
      await DefineHandler(event: event, data: data, ctx: ctx).handle()
    case .presence:
      await PresenceHandler(event: event, data: data, ctx: ctx).handle()
    case .sunny:
      await SunnyHandler(event: event, data: data, ctx: ctx).handle()
    case .link:
      await LinkHandler(event: event, data: data, ctx: ctx).handle()
    default:
      logger.error("Unrecognized command")
      return await sendUnknownCommandFailure()
    }
  }

  private func sendUnknownCommandFailure() async {
    await ctx.services.discordSvc.respondToInteraction(
      id: event.id,
      token: event.token,
      payload: .channelMessageWithSource(
        .init(
          embeds: [
            .init(description: "Failed to resolve the interaction name :(")
          ],
          flags: [.ephemeral]
        )
      )
    )
  }
}
