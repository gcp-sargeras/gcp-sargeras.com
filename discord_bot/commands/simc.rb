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

          RestClient.post(
            "#{ENV['APP_URL']}/simc/reports",
            { report: report(args.first, resp.id),
              requester: requester(event) },
            { Authorization: "Bearer #{ENV['APP_TOKEN']}" }
          )

          nil
        end
      end

      protected

      def report(character, message_id)
        { character: character, message_id: message_id }
      end

      def requester(event)
        { user: { id: event.user.id }, message_id: event.message.id }
      end
    end
  end
end
