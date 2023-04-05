import DiscordBM
import Logging

struct MessageHandler {
  var logger = Logger(label: "MessageHandler")
  var discordService: DiscordService { .shared }

  let event: Gateway.MessageCreate

  func handle() async {
    if event.content.lowercased().contains("h word") {
      await discordService.addReaction(
        channelId: event.channel_id,
        messageId: event.id,
        emoji: "❌"
      )

      await discordService.sendReply(
        channelId: event.channel_id,
        message: "Just say horny oh my god",
        messageId: event.id,
        guildId: event.guild_id
      )
    }
  }
}
