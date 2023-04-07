import DiscordBM
import Logging

struct CommandsManager {
  func registerCommands() async {
    await DiscordService.shared.writeCommands([
      .define,
      .presence,
      .sunny,
      .link,
    ])
  }
}

enum CommandKind {
  case define
  case presence
  case sunny
  case link

  init?(name: String) {
    switch name {
    case "define": self = .define
    case "presence": self = .presence
    case "sunny": self = .sunny
    case "link": self = .link
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

extension RequestBody.ApplicationCommandCreate {
  fileprivate static let link = RequestBody.ApplicationCommandCreate(
    name: "link",
    description: "Babkabot presents: tagged links",
    options: [
      .init(
        type: .subCommand,
        name: "add",
        description: "Add a link to be saved",
        options: [
          .init(
            type: .string,
            name: "url",
            description: "The url of the link",
            required: true
          ),
          .init(
            type: .string,
            name: "description",
            description: "A description for the link",
            required: false
          ),
          .init(
            type: .string,
            name: "tags",
            description: "Comma-separated list of tags",
            required: false
          ),
          .init(
            type: .string,
            name: "privacy",
            description: "How visible you'd like your link to be",
            required: false,
            choices: [
              .init(name: "Global", value: .string("global")),
              .init(name: "This Server Only", value: .string("serverOnly")),
              .init(name: "Private", value: .string("personal")),
            ]
          ),
        ]
      ),
      .init(
        type: .subCommand,
        name: "search",
        description: "Search for a link",
        options: [
          .init(
            type: .string,
            name: "text",
            description: "Search text",
            required: true
          )
        ]
      ),
    ]
  )
}
