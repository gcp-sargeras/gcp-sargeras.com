# frozen_string_literal: true

module DiscordBot
  module Commands
    class Simc
      def initialize(bot)
        @bot = bot
      end

      def subscribe
        @bot.command :sim do |event, *args|
          return 'please enter character name first' if args.first =~ /```/

          resp = event.respond("adding #{args.first} to queue")

          queue_report(event, args, resp)

          nil
        end
      end

      def queue_report(event, args, resp)
        catch_error(event, resp) do
          RestClient.post(
            "#{ENV['APP_URL']}/simc/reports",
            { report: report(args.first, resp.id, event) },
            { Authorization: "Bearer #{ENV['APP_TOKEN']}" }
          )
        end
      end

      protected

      def catch_error(event, resp)
        yield
      rescue => e
        resp.delete
        event.respond(
          "#{event.user.mention} An error has occurred while trying to place you in queue, please try again later."
        )
        raise e
      end

      def report(character, message_id, event)
        custom_string = /```(.|\s|\n)+```/.match(event.message.content)&.to_s&.delete('```')&.strip

        { character: character, message_id: message_id, requester_id: event.user.id,
          requester_message_id: event.message.id, requester_channel_id: event.message.channel.id,
          requester_attachment_url: event.message.attachments&.first&.url, custom_string: custom_string }
      end
    end
  end
end
