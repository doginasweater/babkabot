import DiscordBM
import Logging

actor GatewayService {
  private let gatewayManager: BotGatewayManager
  private let logger = Logger(label: "GatewayService")

  init(bot: BotGatewayManager) {
    self.gatewayManager = bot
  }

  func updatePresence(
    name: String,
    type: Gateway.Activity.Kind,
    status: Gateway.Status,
    afk: Bool = false
  ) async {
    logger.info(
      "Writing new presence",
      metadata: [
        "name": "\(name)",
        "type": "\(type)",
        "status": "\(status)",
      ])

    await gatewayManager.updatePresence(
      payload: .init(
        activities: [.init(name: name, type: type)],
        status: status,
        afk: afk
      ))

    logger.info("Presence theoretically updated")
  }
}
