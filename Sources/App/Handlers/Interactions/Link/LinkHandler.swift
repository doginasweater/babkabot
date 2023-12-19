import AsyncHTTPClient
import DiscordBM
import Foundation
import Logging
import SwiftPrettyPrint

struct LinkHandler: Handler {
  let event: Interaction
  let data: Interaction.ApplicationCommand
  let ctx: Context

  func handle() async {
    let svc = ctx.services.discordSvc
    let options = data.options ?? []

    if options.isEmpty {
      await svc.sendFailure(event: event, message: "No options sent")
      return
    }

    guard let command = LinkCommand(options[0].name) else {
      await sendFailure("Unknown subcommand")
      return
    }

    guard let subOptions = options[0].options else {
      await sendFailure("No options found")
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
    let repo = ctx.services.repo
    let svc = ctx.services.discordSvc
    let url = options.first(where: { $0.name == AddOption.url.v })?.value?.asString

    guard let url else {
      await sendFailure("You have to at least send a url")
      return
    }

    let description = options.first(where: { $0.name == AddOption.description.v })?.value?.asString
    let privacy = Privacy(options.first(where: { $0.name == AddOption.privacy.v })?.value?.asString)
    let serverId = event.guild_id
    let channelId = event.channel_id
    let userId = event.member?.user?.username
    let rawTags = options.first(where: { $0.name == AddOption.tags.v })?.value?.asString

    let link = Link(
      title: description ?? "",
      url: url,
      createdBy: userId ?? "",
      fromServer: serverId?.rawValue ?? "",
      fromChannel: channelId?.rawValue ?? "",
      privacy: privacy
    )

    let tags = await processTags(rawTags, event: event, privacy: privacy)

    do {
      try await repo.saveLink(link: link, tags: tags)

      await svc.respondToInteraction(
        id: event.id,
        token: event.token,
        payload: .channelMessageWithSource(
          .init(
            content: "Saved link to \(url)!"
          )
        )
      )
    } catch {
      logger.report(
        "Unable to save link", error: error,
        metadata: [
          "link": "\(link)"
        ])

      await sendFailure("Unable to save link")
    }
  }

  func handleSearch(_ options: [Interaction.ApplicationCommand.Option]) async {

  }

  func handleList(_ options: [Interaction.ApplicationCommand.Option]) async {
    let repo = ctx.services.repo
    let svc = ctx.services.discordSvc
    let privacy = Privacy(options.first(where: { $0.name == "filter" })?.value?.asString)

    do {
      var links: [Link]

      if privacy == .personal {
        guard let id = event.member?.user?.id.rawValue else {
          await sendFailure("Unable to get user id")
          return
        }

        links = try await repo.getLinks(filter: privacy, id: id)
      } else if privacy == .serverOnly {
        guard let id = event.guild_id?.rawValue else {
          await sendFailure("Unable to get server id")
          return
        }

        links = try await repo.getLinks(filter: privacy, id: id)
      } else {
        await sendFailure("Invalid filter value")
        return
      }

      let embeds =
        links.isEmpty
        ? [.init(title: "\(event.member?.user?.username ?? "This person") has no links stored")]
        : links.map { link in
          Embed(
            title: link.title,
            type: .link,
            description: """
              URL: \(link.url)
              Tags: \(link.tags.isEmpty ? "None" : String(link.tags.map { $0.name }.joined(by: ", ")))
              Created by \(link.createdBy) at \(link.createdAt?.format(using: .MMddyy) ?? "unknown")
              """,
            url: link.url
          )
        }

      await svc.respondToInteraction(
        id: event.id,
        token: event.token,
        payload: .channelMessageWithSource(
          .init(
            embeds: embeds
          )
        )
      )
    } catch {
      logger.report("Unable to get links", error: error)
    }
  }

  private func processTags(_ tags: String?, event: Interaction, privacy: Privacy) async -> [Tag] {
    let repo = ctx.services.repo

    guard let tags else {
      return []
    }

    let tagNames =
      tags
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .lowercased()
      .split(separator: ",", omittingEmptySubsequences: true)
      .map { String($0) }

    do {
      let dbTags = try await repo.getTags(names: tagNames, server: event.guild_id?.rawValue ?? "")

      return try tagNames.map { (tag: String) in
        let existingTag = dbTags.first(where: { $0.name == tag })

        return Tag(
          id: try existingTag?.requireID() ?? UUID(),
          name: existingTag?.name ?? tag,
          fromServer: existingTag?.fromServer ?? event.guild_id?.rawValue ?? "",
          fromChannel: existingTag?.fromChannel ?? event.channel_id?.rawValue ?? "",
          privacy: existingTag?.privacy ?? privacy
        )
      }
    } catch {
      logger.report("Can't find tags :(", error: error, metadata: ["tags": "\(tagNames)"])

      return []
    }
  }
}
