import AsyncHTTPClient
import DiscordBM
import Logging

struct EventHandler: GatewayEventHandler {
  let event: Gateway.Event
  let ctx: Context

  func onMessageCreate(_ payload: Gateway.MessageCreate) async throws {
    await MessageHandler(event: payload, ctx: ctx).handle()
  }

  func onInteractionCreate(_ payload: Interaction) async throws {
    await InteractionHandler(event: payload, ctx: ctx).handle()
  }
}
