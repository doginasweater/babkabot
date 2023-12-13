import AsyncHTTPClient
import DiscordBM
import Foundation
import Logging

struct DefineHandler: Handler {
  let event: Interaction
  let data: Interaction.ApplicationCommand
  let ctx: Context

  func handle() async {
    let options = data.options ?? []

    if options.isEmpty {
      logger.error("Options is empty")
      await sendFailure("You didn't give me a word to define")
    }

    guard let word = options[0].value?.asString else {
      await sendFailure("You didn't give me a word to define")
      return
    }

    do {
      try await getWordDefinition(word)
    } catch {
      logger.report("Unable to get definition for \(word)", error: error)
      await sendFailure("Error occurred while getting definition for **\(word)**")
    }
  }

  private func getWordDefinition(_ word: String) async throws {
    let client = ctx.services.httpClient

    let request = HTTPClientRequest(url: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)")
    let response = try await client.execute(request, timeout: .seconds(30), logger: self.logger)

    guard response.status.code == 200 else {
      if response.status.code == 404 {
        await sendFailure("Unable to find definition for **\(word)**. Does that word exist? Did you spell it right?")
      } else {
        logger.error(
          "Request for \(word) failed",
          metadata: [
            "status": "\(response.status.code)"
          ])
        await sendFailure("Unable to find definition for **\(word)**. Seems like it might be an API error")
      }

      return
    }

    let body = try await response.body.collect(upTo: 1 << 24)
    let apiResponse = try JSONDecoder().decode([ApiResponse].self, from: body)

    guard apiResponse.count > 0 else {
      await sendFailure("No meanings found for **\(word)**")
      return
    }

    let dictResponse =
      apiResponse
      .compactMap { $0 }
      .compactMap { $0.meanings }
      .flatMap { $0 }
      .map { meaning -> [String?] in
        let d = meaning.definitions?.compactMap { $0 } ?? []

        return d.map { def in
          if meaning.partOfSpeech == nil || def.definition == nil {
            return nil
          }

          return "**(\(meaning.partOfSpeech ?? ""))** \(def.definition ?? "")"
        }
      }
      .flatMap { $0 }
      .compactMap { $0 }
      .joined(separator: "\n")

    await respond(word, dictResponse)
  }

  private func respond(_ word: String, _ response: String) async {
    await ctx.services.discordSvc.respondToInteraction(
      id: event.id,
      token: event.token,
      payload: .channelMessageWithSource(
        .init(
          embeds: [
            .init(
              title: "Definition for **\(word)**",
              description: response
            )
          ]
        )
      )
    )
  }

  private func acknowledge(isEphemeral: Bool) async -> Bool {
    await ctx.services.discordSvc.respondToInteraction(
      id: event.id,
      token: event.token,
      payload: .deferredChannelMessageWithSource(isEphemeral: isEphemeral)
    )
  }
}
