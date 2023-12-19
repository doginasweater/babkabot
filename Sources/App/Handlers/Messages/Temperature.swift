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
      let msg: String?

      if ["c", "f"].contains(match.2), let value = Double(match.1) {
        msg = getMsg(from: match.2, value: value)
      } else {
        await sendFailure("Unable to parse temperature")

        return
      }

      if let msg {
        await client.sendReply(
          channelId: event.channel_id,
          message: msg,
          messageId: event.id,
          guildId: event.guild_id
        )
      }
    }
  }

  func getMsg(from: Substring, value: Double) -> String? {
    if !["c", "f"].contains(from) {
      return nil
    }

    if TemperatureCache.hasKey(value) {
      return nil
    }

    let converted = switch from {
    case "c":
      toF(value)
    case "f":
      toC(value)
    default:
      0
    }

    TemperatureCache.add(key: value, value: converted)

    return "I think you mean \(converted)°\(from == "c" ? "F" : "C")"
  }

  func toF(_ c: Double) -> Int {
    Int(round((c * (9.0 / 5.0)) + 32))
  }

  func toC(_ f: Double) -> Int {
    Int(round((f - 32.0) * (5.0 / 9.0)))
  }
}

struct TemperatureCache {
  struct CacheEntry {
    let value: Int
    let expires: Date

    var expired: Bool {
      Date() > expires
    }
  }

  static var cache: [Double: CacheEntry] = [:]

  static func hasKey(_ key: Double) -> Bool {
    guard let entry = cache[key] else {
      return false
    }

    if entry.expired {
      cache.removeValue(forKey: key)

      return false
    }

    return true
  }

  static func add(key: Double, value: Int) {
    cache[key] = CacheEntry(value: value, expires: Date.now.addingTimeInterval(600))
  }
}
