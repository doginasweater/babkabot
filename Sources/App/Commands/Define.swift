import AsyncHTTPClient
import DiscordBM
import Foundation
import Logging

struct DefineHandler {
  var logger = Logger(label: "DefineHandler")
  var discordService: DiscordService { .shared }

  let client: HTTPClient
  let event: Interaction

  init(event: Interaction, client: HTTPClient) {
    self.event = event
    self.client = client
  }

  func handle() async {
    guard case let .applicationCommand(data) = event.data,
      CommandKind(name: data.name) != nil else {
        logger.error("Unrecognized command")
        return await sendUnknownCommandFailure()
      }

    let options = data.options ?? []

    if options.isEmpty {
      logger.error("Options is empty")
      await sendFailure(message: "You didn't give me a word to define")
    }

    guard let word = options[0].value?.asString else {
      await sendFailure(message: "You didn't give me a word to define")
      return
    }

    do {
      try await getWordDefinition(word)
    } catch {
      logger.report("Unable to get definition for \(word)", error: error)
      await sendFailure(message: "Error occurred while getting definition")
    }
  }

  private func getWordDefinition(_ word: String) async throws {
    let request = HTTPClientRequest(url: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)")
    let response = try await client.execute(request, timeout: .seconds(30), logger: self.logger)

    guard response.status.code == 200 else {
      logger.error("Request for \(word) failed")

      await sendFailure(message: "Unable to find definition for \(word). Seems like it might be an API error")

      return
    }

    let body = try await response.body.collect(upTo: 1 << 24)

    let apiResponse = try JSONDecoder().decode([ApiResponse].self, from: body)

    guard apiResponse.count > 0 else {
      logger.error("No meanings found for \(word)")
      await sendFailure(message: "No meanings found for \(word)")
      return
    }

    let dictResponse = apiResponse
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
    await discordService.respondToInteraction(
      id: event.id,
      token: event.token,
      payload: .init(
        type: .channelMessageWithSource,
        data: .init(
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

  private func sendUnknownCommandFailure() async {
    await discordService.respondToInteraction(
      id: event.id,
      token: event.token,
      payload: .init(
        type: .channelMessageWithSource,
        data: .init(
          embeds: [
            .init(description: "Failed to resolve the interaction name :(")
          ],
          flags: [.ephemeral]
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

  private func acknowledge(isEphemeral: Bool) async -> Bool {
    await discordService.respondToInteraction(
      id: event.id,
      token: event.token,
      payload: .init(
        type: .deferredChannelMessageWithSource,
        data: isEphemeral ? .init(flags: [.ephemeral]) : nil
      )
    )
  }
}
