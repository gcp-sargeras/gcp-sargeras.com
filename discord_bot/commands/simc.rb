# frozen_string_literal: true

module DiscordBot
  module Commands
    class Simc
      def initialize(bot)
        @bot = bot
      end

      def subscribe
        @bot.command :sim do |event, *args|
          resp = event.respond("Starting sim for #{args.first}")
          RestClient.post("#{ENV['APP_URL']}/simc/reports", { report: { character: args.first, message_id: resp.id } }, headers={})

          nil
        end
      end
    end
  end
end
