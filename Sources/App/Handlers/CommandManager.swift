import DiscordBM
import Logging

struct CommandManager {
  let client: any DiscordClient

  func registerCommands() async throws {
    let commands = makeCommands()

    try await client.bulkSetApplicationCommands(payload: commands)
      .guardSuccess()
  }

  private func makeCommands() -> [Payloads.ApplicationCommandCreate] {
    SlashCommand.allCases.map { command in
      Payloads.ApplicationCommandCreate(
        name: command.rawValue,
        description: command.description,
        options: command.options,
        dm_permission: true
      )
    }
  }
}

enum SlashCommand: String, CaseIterable {
  case define
  case presence
  case sunny
  case link

  var description: String? {
    switch self {
    case .define: "Define a word!"
    case .presence: "What is babkabot doing?"
    case .sunny: "Make an It's Always Sunny in Philadelphia title card"
    case .link: "Babkabot presents: tagged links"
    }
  }

  var options: [ApplicationCommand.Option]? {
    switch self {
    case .define:
      [
        ApplicationCommand.Option(
          type: .string,
          name: "word",
          description: "The word you'd like to define",
          required: true
        )
      ]
    case .presence:
      [
        ApplicationCommand.Option(
          type: .string,
          name: "activity",
          description: "The name of the activity",
          required: true
        ),
        ApplicationCommand.Option(
          type: .string,
          name: "type",
          description: "What kind of thing is it?",
          required: true,
          choices: [
            .init(name: "game", value: .string("game")),
            .init(name: "listening", value: .string("listening")),
          ]
        ),
      ]
    case .sunny:
      [
        ApplicationCommand.Option(
          type: .string,
          name: "title",
          description: "The name of the episode",
          required: true
        )
      ]
    case .link:
      LinkSubCommand.allCases.map { subCommand in
        ApplicationCommand.Option(
          type: .subCommand,
          name: subCommand.rawValue,
          description: subCommand.description,
          options: subCommand.options
        )
      }
    }
  }
}
