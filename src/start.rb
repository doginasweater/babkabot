# frozen_string_literal: true
# typed: strict

require 'dotenv'
require 'discordrb'

Dotenv.load

bot = Discordrb::Bot.new(token: ENV.fetch('DISCORD_API_TOKEN'), intents: [:server_messages])

bot.message(with_text: 'Ping!') { |event| event.respond 'Pong!' }

bot.mention do |event|
  event.user.pm('What did you fucking say to me?')
end

bot.register_application_command(:example, 'Example command', server_id: ENV.fetch('TEST_SERVER', nil)) do |cmd|
end

bot.application_command(:example) do |event|
  event.respond(content: 'hello!')
end

puts "Bot is now running! To install, you'll need the following URL"
puts bot.invite_url

bot.run
