import DiscordBM

enum LinkSubCommand: String, CaseIterable {
  case add, search, list

  var description: String {
    switch self {
    case .add: "Add a link to be saved"
    case .list: "List all links"
    case .search: "Search for a link"
    }
  }

  var options: [ApplicationCommand.Option] {
    switch self {
    case .add:
      [
        .init(
          type: .string,
          name: AddOption.url.v,
          description: "The url of the link",
          required: true
        ),
        .init(
          type: .string,
          name: AddOption.description.v,
          description: "A description for the link",
          required: false
        ),
        .init(
          type: .string,
          name: AddOption.tags.v,
          description: "Comma-separated list of tags",
          required: false
        ),
        .init(
          type: .string,
          name: AddOption.privacy.v,
          description: "How visible you'd like your link to be",
          required: false,
          choices: [
            .init(name: "Global", value: .string("global")),
            .init(name: "This Server Only", value: .string("serverOnly")),
            .init(name: "Private", value: .string("personal")),
          ]
        ),
      ]
    case .list:
      [
        .init(
          type: .string,
          name: "filter",
          description: "Types of links to show",
          required: false,
          choices: [
            .init(name: "Mine", value: .string("personal")),
            .init(name: "Server", value: .string("serverOnly")),
          ]
        )
      ]
    case .search:
      [
        .init(
          type: .string,
          name: "text",
          description: "Search text",
          required: true
        )
      ]
    }
  }
}
