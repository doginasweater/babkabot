import AsyncHTTPClient
import DiscordBM
import Foundation
import Logging
import SwiftPrettyPrint

struct LinkHandler {
  var logger = Logger(label: String(describing: LinkHandler.self))
  var svc: DiscordService { .shared }

  let client: HTTPClient
  let event: Interaction
  let data: Interaction.ApplicationCommand

  init(event: Interaction, data: Interaction.ApplicationCommand, client: HTTPClient) {
    self.event = event
    self.data = data
    self.client = client
  }

  func handle() async {
    let options = data.options ?? []

    if options.isEmpty {
      await svc.sendFailure(event: event, message: "No options sent")
      return
    }

    switch options[0].name {
    case "add":
      await handleAdd(options[0].options)
    case "search":
      await handleSearch(options[0].options)
    default:
      await svc.sendFailure(event: event, message: "Unknown subcommand")
    }
  }

  func handleAdd(_ options: [Interaction.ApplicationCommand.Option]?) async {

  }

  func handleSearch(_ options: [Interaction.ApplicationCommand.Option]?) async {

  }
}
