import AsyncHTTPClient

struct Context: Sendable {
  struct Services: Sendable {
    let discordSvc: DiscordService
    let gatewaySvc: GatewayService
    let httpClient: HTTPClient
    let repo: Repo
  }

  let services: Services
}
