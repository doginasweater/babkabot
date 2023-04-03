import DiscordBM
import Logging

struct CommandsManager {
  func registerCommands() async {
    await DiscordService.shared.writeCommands([
      .define,
      .presence
    ])
  }
}

enum CommandKind {
  case define
  case presence

  var isEphemeral: Bool {
    switch self {
      case .define: return true
      case .presence: return true
    }
  }

  init? (name: String) {
    switch name {
      case "define": self = .define
      case "presence": self = .presence
      default: return nil
    }
  }
}

private extension RequestBody.ApplicationCommandCreate {
  static let define = RequestBody.ApplicationCommandCreate(
    name: "define",
    description: "Define a word!",
    options: [
      .init(
        type: .string,
        name: "word",
        description: "The word you'd like to define",
        required: true
      )
    ]
  )
}

private extension RequestBody.ApplicationCommandCreate {
  static let presence = RequestBody.ApplicationCommandCreate(
    name: "presence",
    description: "What is babkabot doing?",
    options: [
      .init(
        type: .string,
        name: "activity",
        description: "The name of the activity",
        required: true
      ),
      .init(
        type: .string,
        name: "type",
        description: "What kind of thing is it?",
        required: true,
        choices: [
          .init(name: "game", value: .string("game")),
          .init(name: "listening", value: .string("listening"))
        ]
      )
    ]
  )
}
