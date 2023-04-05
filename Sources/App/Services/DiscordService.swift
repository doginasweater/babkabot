import DiscordBM
import Logging

actor DiscordService {
  private var discordClient: (any DiscordClient)!
  private var logger = Logger(label: "DiscordService")

  private init() {}

  static let shared = DiscordService()

  func initialize(client: any DiscordClient) {
    self.discordClient = client
  }

  func writeCommands(_ commands: [RequestBody.ApplicationCommandCreate]) async {
    do {
      try await discordClient
        .bulkSetApplicationCommands(payload: commands)
        .guardSuccess()
    } catch {
      logger.report(
        "Couldn't overwrite application commands.", error: error,
        metadata: [
          "commands": "\(commands)"
        ])
    }
  }

  @discardableResult
  func respondToInteraction(id: String, token: String, payload: RequestBody.InteractionResponse)
    async -> Bool
  {
    do {
      try await discordClient.createInteractionResponse(
        id: id,
        token: token,
        payload: payload
      ).guardSuccess()

      return true
    } catch {
      logger.report(
        "Couldn't send interaction response", error: error,
        metadata: [
          "id": .string(id),
          "token": .string(token),
          "payload": "\(payload)",
        ])

      return false
    }
  }

  func editInteraction(token: String, payload: RequestBody.InteractionResponse.CallbackData) async {
    do {
      try await discordClient.updateOriginalInteractionResponse(
        token: token,
        payload: payload
      ).guardSuccess()
    } catch {
      logger.report(
        "Couldn't send interaction edit", error: error,
        metadata: [
          "token": .string(token),
          "payload": "\(payload)",
        ])
    }
  }
}
