import DiscordBM
import Foundation
import Logging

struct MessageHandler {
  let logger = Logger(label: "MessageHandler")
  let event: Gateway.MessageCreate
  let ctx: Context

  func handle() async {
    let handlers: [MsgHandler] = [
      TemperatureHandler(event: event, ctx: ctx),
      HWordHandler(event: event, ctx: ctx),
    ]

    for handler in handlers {
      if handler.test() {
        await handler.handle()
      }
    }
  }
}
