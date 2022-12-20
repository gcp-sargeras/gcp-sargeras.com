# frozen_string_literal: true

module DiscordBot
  module Commands
    # command for simulating a character
    class Simc
      def initialize(bot)
        @bot = bot
      end

      def subscribe
        @bot.command :sim do |event, *args|
          return 'please enter character name first' if args.first =~ /```/

          resp = event.respond("adding #{args.first} to queue")

          catch_error(event, resp) { queue_report(event, args, resp) }

          nil
        end
      end

      def queue_report(event, args, resp)
        return already_in_queue_message(resp, event) if user_already_in_queue?(event.user.id)

        report = create_report!(character(args.first), resp.id, event)
        resp.edit("#{args.first} added to queue")

        DiscordReportSimcWorker.perform_async(report.id)
      end

      protected

      def already_in_queue_message(resp, event)
        resp.edit("#{event.user.mention} you are already in queue")
      end

      def catch_error(event, resp)
        yield
      rescue StandardError => e
        resp.delete
        event.respond(
          "#{event.user.mention} An error has occurred while trying to place you in queue, please try again later."
        )
        raise e
      end

      def character(name)
        region = Wow::Region.find_by(name: 'us')
        server = Wow::Server.find_by(name: 'sargeras')
        Wow::Character.find_or_create_by!(name: name.downcase, server: server, region: region)
      end

      def create_report!(character, message_id, event)
        custom_string = /```(.|\s|\n)+```/.match(event.message.content)&.to_s&.delete('```')&.strip

        ::Simc::Report.create(character:, message_id:, requester_id: event.user.id,
                              requester_message_id: event.message.id, requester_channel_id: event.message.channel.id,
                              requester_attachment_url: event.message.attachments&.first&.url, custom_string:)
      end

      def user_already_in_queue?(requester_id)
        ::Simc::Report.where(id: current_ids_in_queue,
                             requester_id:).present?
      end

      def current_ids_in_queue
        [
          *Sidekiq::Queue.new('default').filter { |w| w.klass == 'SimcWorker' }.map { |w| w.args.first },
          *Sidekiq::Workers.new.filter { |_, _, w| w['queue'] == 'default' && w['payload']['class'] == 'SimcWorker' }
                           .map { |_, _, w| w['payload']['args'].first }
        ]
      end
    end
  end
end
