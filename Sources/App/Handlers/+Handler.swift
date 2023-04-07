import AsyncHTTPClient
import DiscordBM
import Logging

protocol Handler {
  var logger: Logger { get }
  var svc: DiscordService { get }
  var client: HTTPClient { get }
  var event: Interaction { get }
  var data: Interaction.ApplicationCommand { get }

  func handle() async
}

extension Handler {
  var svc: DiscordService { .shared }
  var logger: Logger { Logger(label: String(describing: Self.self)) }

  func sendFailure(message: String) async {
    await svc.respondToInteraction(
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
}
