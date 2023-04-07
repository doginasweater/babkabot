import AsyncHTTPClient
import DiscordBM
import Foundation
import Logging
import SwiftPrettyPrint

struct LinkHandler: Handler {
  let event: Interaction
  let data: Interaction.ApplicationCommand
  let client: HTTPClient

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
      await sendFailure(message: "Unknown subcommand")
    }
  }

  func handleAdd(_ options: [Interaction.ApplicationCommand.Option]?) async {

  }

  func handleSearch(_ options: [Interaction.ApplicationCommand.Option]?) async {

  }
}
