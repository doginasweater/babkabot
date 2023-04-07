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

    guard let command = LinkCommand(options[0].name) else {
      await sendFailure(message: "Unknown subcommand")
      return
    }

    guard let subOptions = options[0].options else {
      await sendFailure(message: "No options found")
      return
    }

    switch command {
    case .add:
      await handleAdd(subOptions)
    case .search:
      await handleSearch(subOptions)
    case .list:
      await handleList(subOptions)
    }
  }

  func handleAdd(_ options: [Interaction.ApplicationCommand.Option]) async {
    let url = options.first(where: { $0.name == "url" })?.value?.asString
    let description = options.first(where: { $0.name == "description" })?.value?.asString
    // let tags = options.first(where: { $0.name == "tags" })?.value?.asString
    let privacy = Privacy(options.first(where: { $0.name == "privacy" })?.value?.asString)
    let serverId = event.guild_id
    let channelId = event.channel_id
    let userId = event.member?.user?.id

    guard let url else {
      await sendFailure(message: "You have to at least send a url")
      return
    }

    let link = Link(
      title: description ?? "",
      url: url,
      createdBy: userId ?? "",
      fromServer: serverId ?? "",
      fromChannel: channelId ?? "",
      privacy: privacy
    )

    do {
      try await LinkRepo.shared.saveLink(link: link)

      await svc.respondToInteraction(
        id: event.id,
        token: event.token,
        payload: .init(
          type: .channelMessageWithSource,
          data: .init(
            content: "Saved link!"
          )
        )
      )
    } catch {
      logger.report(
        "Unable to save link", error: error,
        metadata: [
          "link": "\(link)"
        ])
      await sendFailure(message: "Unable to save link")
    }
  }

  func handleSearch(_ options: [Interaction.ApplicationCommand.Option]) async {

  }

  func handleList(_ options: [Interaction.ApplicationCommand.Option]) async {
    let privacy = Privacy(options.first(where: { $0.name == "privacy" })?.value?.asString)

    do {
      var links: [Link]

      if privacy == .personal {
        guard let id = event.member?.user?.id else {
          await sendFailure(message: "Unable to get user id")
          return
        }

        links = try await LinkRepo.shared.getLinks(filter: privacy, id: id)
      } else if privacy == .serverOnly {
        guard let id = event.guild_id else {
          await sendFailure(message: "Unable to get server id")
          return
        }

        links = try await LinkRepo.shared.getLinks(filter: privacy, id: id)
      } else {
        await sendFailure(message: "Invalid filter value")
        return
      }

      await svc.respondToInteraction(
        id: event.id,
        token: event.token,
        payload: .init(
          type: .channelMessageWithSource,
          data: .init(
            embeds: links.map { link in
              Embed(
                title: link.url,
                description: """
                  \(link.title)
                  """
              )
            }
          )
        )
      )
    } catch {
      logger.report("Unable to get links", error: error)
    }
  }
}
