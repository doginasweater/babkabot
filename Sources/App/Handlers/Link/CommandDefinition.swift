import DiscordBM

extension RequestBody.ApplicationCommandCreate {
  static let link = RequestBody.ApplicationCommandCreate(
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
      .init(
        type: .subCommand,
        name: "list",
        description: "List all links",
        options: [
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
      ),
    ]
  )
}
