# frozen_string_literal: true

module DiscordBot
  module Commands
    class Roast
      def initialize(bot)
        @bot = bot
      end

      def subscribe
        @bot.command :roast do |_event|
          DiscordBot::Assets::Roasts.sample
        end
      end
    end
  end
end
