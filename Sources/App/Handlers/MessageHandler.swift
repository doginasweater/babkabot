import DiscordBM
import Foundation
import Logging

struct MessageHandler {
  var logger = Logger(label: "MessageHandler")
  var discordService: DiscordService { .shared }

  let event: Gateway.MessageCreate

  func handle() async {
    let content = event.content.lowercased()

    if content.contains("h word") {
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
    } else if let match = content.firstMatch(of: /(-?[0-9]{1,2})c/),
      let c = Double(match.1)
    {
      await discordService.sendReply(
        channelId: event.channel_id,
        message: "I think you mean \(toF(c))°F",
        messageId: event.id,
        guildId: event.guild_id
      )
    } else if let match = content.firstMatch(of: /(-?[0-9]{1,3})f/),
      let f = Double(match.1)
    {
      await discordService.sendReply(
        channelId: event.channel_id,
        message: "I think you mean \(toC(f))°C",
        messageId: event.id,
        guildId: event.guild_id
      )
    }
  }

  func toF(_ c: Double) -> Int {
    Int(round((c * (9.0 / 5.0)) + 32))
  }

  func toC(_ f: Double) -> Int {
    Int(round((f - 32.0) * (5.0 / 9.0)))
  }
}
