import DiscordBM
import Logging

struct CommandsManager {
  func registerCommands() async {
    await DiscordService.shared.writeCommands([
      .define
    ])
  }
}

enum CommandKind {
  case define

  var isEphemeral: Bool {
    switch self {
      case .define: return true
    }
  }

  init? (name: String) {
    switch name {
      case "define": self = .define
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
