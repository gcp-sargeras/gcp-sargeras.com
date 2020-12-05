# frozen_string_literal: true

module DiscordBot
  module Commands
    class Simc
      def initialize(bot)
        @bot = bot
      end

      def subscribe
        @bot.command :sim do |_event, *args|
          RestClient.post("#{ENV['APP_URL']}/simc/reports", { report: { character: args.first } }, headers={})

          "Starting sim for #{args.first}"
        end
      end
    end
  end
end
