import DiscordBM
import Foundation
import Logging

struct MessageHandler {
  let logger = Logger(label: "MessageHandler")
  let event: Gateway.MessageCreate
  let ctx: Context

  func handle() async {
    let tempHandler = TemperatureHandler(event: event, ctx: ctx)

    if tempHandler.test() {
      await tempHandler.handle()

      return
    }

    let hWordHandler = HWordHandler(event: event, ctx: ctx)

    if hWordHandler.test() {
      await hWordHandler.handle()

      return
    }
  }
}
