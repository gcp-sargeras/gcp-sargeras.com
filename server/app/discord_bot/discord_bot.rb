# frozen_string_literal: true

module DiscordBot
  class Bot
    def initialize
      @bot = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_TOKEN'], prefix: 'gcp'

      subscribe
    end

    def start
      @bot.run
    end

    private

    def subscribe
      # To fill in with listeners to subscribe to
    end
  end
end
