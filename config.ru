# frozen_string_literal: true

require './src/start'

run do |_env|
  app = Main.new
  app.run
end
