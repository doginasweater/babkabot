import DiscordBM
import Logging

struct CommandsManager {
  func registerCommands() async {
    await DiscordService.shared.writeCommands([
      .define,
      .presence,
      .sunny,
    ])
  }
}

enum CommandKind {
  case define
  case presence
  case sunny

  init?(name: String) {
    switch name {
    case "define": self = .define
    case "presence": self = .presence
    case "sunny": self = .sunny
    default: return nil
    }
  }
}

extension RequestBody.ApplicationCommandCreate {
  fileprivate static let define = RequestBody.ApplicationCommandCreate(
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

extension RequestBody.ApplicationCommandCreate {
  fileprivate static let presence = RequestBody.ApplicationCommandCreate(
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
          .init(name: "listening", value: .string("listening")),
        ]
      ),
    ]
  )
}

extension RequestBody.ApplicationCommandCreate {
  fileprivate static let sunny = RequestBody.ApplicationCommandCreate(
    name: "sunny",
    description: "Make an It's Always Sunny in Philadelphia title card",
    options: [
      .init(
        type: .string,
        name: "title",
        description: "The name of the episode",
        required: true
      )
    ]
  )
}
