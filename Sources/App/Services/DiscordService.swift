import DiscordBM
import Logging

/// DiscordService is the primary way of interacting with the Discord API
public actor DiscordService {
  private var discordClient: (any DiscordClient)!
  private var logger = Logger(label: "DiscordService")

  private init() {}

  /// As the service is a singleton, all access should go through this shared property
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

  func sendMessage(channelId: String, message: String) async {
    do {
      try await discordClient.createMessage(
        channelId: channelId,
        payload: .init(content: message)
      ).guardSuccess()
    } catch {
      logger.report(
        "Couldn't send message", error: error,
        metadata: [
          "channelId": .string(channelId),
          "payload": "\(message)",
        ])
    }
  }

  func sendReply(channelId: String, message: String, messageId: String, guildId: String?) async {
    do {
      try await discordClient.createMessage(
        channelId: channelId,
        payload: .init(
          content: message,
          message_reference: .init(
            message_id: messageId,
            channel_id: channelId,
            guild_id: guildId,
            fail_if_not_exists: false
          )
        )
      ).guardSuccess()
    } catch {
      logger.report(
        "Couldn't send reply", error: error,
        metadata: [
          "channelId": .string(channelId),
          "payload": "\(message)",
        ])
    }
  }

  func addReaction(channelId: String, messageId: String, emoji: String) async {
    do {
      try await discordClient.addOwnMessageReaction(
        channelId: channelId,
        messageId: messageId,
        emoji: .unicodeEmoji(emoji)
      ).guardSuccess()
    } catch {
      logger.report(
        "Unable to add reaction to message", error: error,
        metadata: [
          "channelId": .string(channelId),
          "messageId": .string(messageId),
        ])
    }
  }

  func editMessage(channelId: String, messageId: String, newContent: String) async {
    do {
      try await discordClient.updateMessage(
        channelId: channelId,
        messageId: messageId,
        payload: .init(content: newContent)
      ).guardSuccess()
    } catch {
      logger.report(
        "Unable to modify message", error: error,
        metadata: [
          "channelId": .string(channelId),
          "messageId": .string(messageId),
          "content": .string(newContent),
        ])
    }
  }
}
