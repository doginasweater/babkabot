# frozen_string_literal: true
# typed: strict

require 'dotenv'
require 'discordrb'

Dotenv.load

token = ENV.fetch('DISCORD_API_TOKEN')

bot = Discordrb::Bot.new token: token

puts "Bot is now running! To install, you'll need the following URL"
puts bot.invite_url

bot.message(with_text: 'Ping!') { |event| event.respond 'Pong!' }

bot.run
