import AsyncHTTPClient
import DiscordBM
import Foundation
import Logging

struct SunnyRequest: Codable {
  var text: String
}

struct SunnyHandler: Handler {
  let event: Interaction
  let data: Interaction.ApplicationCommand
  let ctx: Context

  func handle() async {
    let options = data.options ?? []

    if options.isEmpty {
      logger.error("Options is empty")
      await sendFailure("Gotta send a title")
    }

    guard
      let title = options.first(where: { $0.name == "title" })?.value?.asString
    else {
      await sendFailure("Gotta send a title")
      return
    }

    do {
      try await getTitleCard(title)
    } catch {
      logger.error(
        "Title card request failed",
        metadata: [
          "title": "\(title)"
        ])

      await sendFailure("Unable to generate a title card :(")
    }
  }

  private func getTitleCard(_ title: String) async throws {
    let client = ctx.services.httpClient

    var request = HTTPClientRequest(url: "https://sunnybot.fly.dev/sunny")
    request.method = .POST
    request.headers.add(name: .contentType, value: "application/json")
    let data = try JSONEncoder().encode(SunnyRequest(text: title))
    request.body = .bytes(data)

    let response = try await client.execute(request, timeout: .seconds(30), logger: self.logger)

    guard response.status.code == 200 else {
      logger.error(
        "Title card request failed",
        metadata: [
          "status": "\(response.status.code)",
          "body": "\(response.body)",
        ])

      await sendFailure("Unable to generate a title card :(")
      return
    }

    let body = try await response.body.collect(upTo: 1 << 24)

    await ctx.services.discordSvc.respondToInteraction(
      id: event.id,
      token: event.token,
      payload: .channelMessageWithSource(
        .init(
          embeds: [.init(title: "Title card", image: .init(url: .attachment(name: "image.png")))],
          files: [.init(data: body, filename: "image.png")]
        )
      )
    )
  }
}
