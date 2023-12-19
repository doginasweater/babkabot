import DiscordBM
import Foundation
import Logging

struct TemperatureHandler: MsgHandler {
  let logger = Logger(label: "TemperatureHandler")
  let event: Gateway.MessageCreate
  let ctx: Context

  let tempRegex = /\b(-?\d{1,3})(c|f)\b/
    .ignoresCase()

  func test() -> Bool {
    event.content.lowercased().contains(tempRegex)
  }

  func handle() async {
    let client = ctx.services.discordSvc
    let content = event.content.lowercased()

    if let match = content.firstMatch(of: tempRegex) {
      let msg: String

      if match.2 == "c", let c = Double(match.1) {
        msg = "I think you mean \(toF(c))°F"
      } else if match.2 == "f", let f = Double(match.1) {
        msg = "I think you mean \(toC(f))°C"
      } else {
        await sendFailure("Unable to parse temperature")

        return
      }

      await client.sendReply(
        channelId: event.channel_id,
        message: msg,
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
