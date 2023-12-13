import DiscordBM
import Logging

/// DiscordService is the primary way of interacting with the Discord API
public actor DiscordService {
  private let discordClient: any DiscordClient
  private let cache: DiscordCache
  private let logger = Logger(label: "DiscordService")

  init(client: any DiscordClient, cache: DiscordCache) {
    self.discordClient = client
    self.cache = cache
  }

  @discardableResult
  func sendMessage(
    channelId: ChannelSnowflake,
    payload: Payloads.CreateMessage
  ) async -> DiscordClientResponse<DiscordChannel.Message>? {
    do {
      let response = try await discordClient.createMessage(
        channelId: channelId,
        payload: payload
      )

      try response.guardSuccess()

      return response
    } catch {
      logger.report(
        "Couldn't send message", error: error,
        metadata: [
          "channelId": "\(channelId)",
          "payload": "\(payload)",
        ])

      return nil
    }
  }

  @discardableResult
  func respondToInteraction(
    id: InteractionSnowflake,
    token: String,
    payload: Payloads.InteractionResponse
  ) async -> Bool {
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
          "id": "\(id)",
          "token": .string(token),
          "payload": "\(payload)",
        ])

      return false
    }
  }

  func editInteraction(
    token: String,
    payload: Payloads.EditWebhookMessage
  ) async {
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

  @discardableResult
  func sendReply(
    channelId: ChannelSnowflake,
    message: String,
    messageId: MessageSnowflake,
    guildId: GuildSnowflake?
  ) async -> DiscordClientResponse<DiscordChannel.Message>? {
    await self.sendMessage(
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
    )
  }

  func addReaction(
    channelId: ChannelSnowflake,
    messageId: MessageSnowflake,
    emoji: String
  ) async {
    do {
      try await discordClient.addMessageReaction(
        channelId: channelId,
        messageId: messageId,
        emoji: .unicodeEmoji(emoji)
      ).guardSuccess()
    } catch {
      logger.report(
        "Unable to add reaction to message", error: error,
        metadata: [
          "channelId": "\(channelId)",
          "messageId": "\(messageId)",
        ])
    }
  }

  func editMessage(
    channelId: ChannelSnowflake,
    messageId: MessageSnowflake,
    newContent: String
  ) async {
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
          "channelId": "\(channelId)",
          "messageId": "\(messageId)",
          "content": "\(newContent)",
        ])
    }
  }
}
