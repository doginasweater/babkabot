import DiscordBM
import Logging

extension DiscordService {
  func sendFailure(event: Interaction, message: String) async {
    await self.respondToInteraction(
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
