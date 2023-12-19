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

protocol MsgHandler {
  var logger: Logger { get }
  var event: Gateway.MessageCreate { get }
  var ctx: Context { get }

  func handle() async
  func test() -> Bool
}

extension MsgHandler {
  func sendFailure(_ message: String) async {
    await self.ctx.services.discordSvc.sendReply(
      channelId: event.channel_id,
      message: message,
      messageId: event.id,
      guildId: event.guild_id
    )
  }
}
