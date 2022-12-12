# frozen_string_literal: true

module DiscordBot
  class Bot
    def initialize
      @bot = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_TOKEN'], prefix: 'gcp '

      subscribe
    end

    def start
      @bot.run
    end

    private

    def subscribe
      Commands::Roast.new(@bot).subscribe
      Commands::Simc.new(@bot).subscribe
    end
  end
end
