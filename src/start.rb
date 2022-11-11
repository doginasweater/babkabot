# frozen_string_literal: true
# typed: strict

require 'rubygems'
require 'bundler/setup'
require 'sorbet-runtime'
require 'dotenv'
require 'discordrb'

Dotenv.load

# appease the rubocop
class Main
  extend T::Sig

  sig { returns(Discordrb::Bot) }
  attr_accessor :bot

  sig { void }
  def initialize
    @bot = T.let(Discordrb::Bot.new(token: ENV.fetch('DISCORD_API_TOKEN'), intents: [:server_messages]),
                 Discordrb::Bot)
  end

  sig { void }
  def init_message
    @bot.message(with_text: 'Ping!') { |event| event.respond 'Pong!' }
  end

  sig { void }
  def init_mention
    @bot.mention do |event|
      event.user.pm('What did you fucking say to me?')
    end
  end

  sig { void }
  def init_command
    @bot.register_application_command(:example, 'Example command', server_id: ENV.fetch('TEST_SERVER', nil)) do |cmd|
    end

    @bot.application_command(:example) do |event|
      event.respond(content: 'hello!')
    end
  end

  sig { void }
  def run
    init_message
    init_mention
    init_command

    puts "Bot is now running! To install, you'll need the following URL"
    puts @bot.invite_url

    @bot.run background: true
  end
end
