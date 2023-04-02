import DiscordBM
import Logging

struct CommandsManager {
  func registerCommands() async {
    await DiscordService.shared.writeCommands([
      .define
    ])
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
