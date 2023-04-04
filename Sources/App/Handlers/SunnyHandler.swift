import AsyncHTTPClient
import DiscordBM
import Foundation
import Logging

struct SunnyRequest: Codable {
  var text: String
}

struct SunnyHandler {
  var logger = Logger(label: "SunnyHandler")
  var discordService: DiscordService { .shared }

  let client: HTTPClient
  let event: Interaction
  let data: Interaction.ApplicationCommand

  init(event: Interaction, data: Interaction.ApplicationCommand, client: HTTPClient) {
    self.event = event
    self.data = data
    self.client = client
  }

  func handle() async {
    let options = data.options ?? []

    if options.isEmpty {
      logger.error("Options is empty")
      await sendFailure(message: "Gotta send a title")
    }

    guard
      let title = options.first(where: { $0.name == "title" })?.value?.asString
    else {
      await sendFailure(message: "Gotta send a title")
      return
    }

    do {
      try await getTitleCard(title)
    } catch {
      logger.error("Title card request failed", metadata: [
        "title": "\(title)"
      ])

      await sendFailure(message: "Unable to generate a title card :(")
    }
  }

  private func getTitleCard(_ title: String) async throws {
    var request = HTTPClientRequest(url: "https://sunnybot.fly.dev/sunny")
    request.method = .POST
    request.headers.add(name: .contentType, value: "application/json")
    let data = try JSONEncoder().encode(SunnyRequest(text: title))
    request.body = .bytes(data)

    let response = try await client.execute(request, timeout: .seconds(30), logger: self.logger)

    guard response.status.code == 200 else {
      logger.error("Title card request failed", metadata: [
        "status": "\(response.status.code)",
        "body": "\(response.body)"
      ])

      await sendFailure(message: "Unable to generate a title card :(")
      return
    }

    let body = try await response.body.collect(upTo: 1 << 24)

    await discordService.respondToInteraction(
      id: event.id,
      token: event.token,
      payload: .init(
        type: .channelMessageWithSource,
        data: .init(
          embeds: [ .init(title: "Title card", image: .init(url: .attachment(name: "image.png"))) ],
          files: [.init(data: body, filename: "image.png")]
        )
      )
    )
  }

  private func sendFailure(message: String) async {
    await discordService.respondToInteraction(
      id: event.id,
      token: event.token,
      payload: .init(
        type: .channelMessageWithSource,
        data: .init(
          embeds: [
            .init(description: message)
          ]
        )
      )
    )
  }
}
