import DiscordBM
import Foundation
import Logging

struct HWordHandler: MsgHandler {
  let logger = Logger(label: "HWordHandler")
  let event: Gateway.MessageCreate
  let ctx: Context

  func test() -> Bool {
    event.content.lowercased().contains("h word")
  }

  func handle() async {
    let client = ctx.services.discordSvc

    await client.addReaction(
      channelId: event.channel_id,
      messageId: event.id,
      emoji: "❌"
    )

    await client.sendReply(
      channelId: event.channel_id,
      message: "Just say horny oh my god",
      messageId: event.id,
      guildId: event.guild_id
    )
  }
}
