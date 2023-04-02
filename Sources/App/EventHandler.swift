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
        case .interactionCreate(let interaction):
          await DefineHandler(event: interaction, client: client).handle()
        default:
          logger.info("Event: \(String(describing: event.data))")
      }
    }
  }
}