import AsyncHTTPClient
import DiscordBM
import Logging

struct EventHandler: Sendable {
  let event: Gateway.Event
  let client: HTTPClient
  let logger = Logger(label: "EventHandler")

  func handle() {
    Task {
      switch event.data {
      case .messageCreate(let message):
        await MessageHandler(event: message).handle()
      case .interactionCreate(let interaction):
        await InteractionHandler(event: interaction, client: client).handle()
      default: break
      }
    }
  }
}
