import AsyncHTTPClient
import DiscordBM
import Logging

protocol Handler {
  var logger: Logger { get }

  var event: Interaction { get }
  var data: Interaction.ApplicationCommand { get }

  var ctx: Context { get }

  func handle() async
}

extension Handler {
  var logger: Logger { Logger(label: String(describing: Self.self)) }

  func sendFailure(_ message: String) async {
    await self.ctx.services.discordSvc.respondToInteraction(
      id: event.id,
      token: event.token,
      payload: .channelMessageWithSource(
        .init(
          embeds: [
            .init(description: message)
          ]
        )
      )
    )
  }
}
