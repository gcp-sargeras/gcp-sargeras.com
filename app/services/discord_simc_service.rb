# frozen_string_literal: true

# Service for running a simc report from discord
class DiscordSimcService < ApplicationService
  attr_reader :report, :bot

  def initialize(report)
    super()

    @report = report
    @bot = Discordrb::Bot.new(token: ENV['DISCORD_TOKEN'])
  end

  def call
    start_time = Time.now
    notify_simulatin_has_begun!

    SimcService.call(report)

    delete_old_message!

    total_time = Time.now - start_time

    send_message(total_time)
  rescue SimcService::SimulationError => e
    error_message(e.message)
  end

  private

  def notify_simulatin_has_begun!
    Discordrb::API::Channel.edit_message(
      "Bot #{ENV['DISCORD_TOKEN']}", report.requester_channel_id, report.message_id,
      "Sim for #{report.character.name} has begun"
    )
  end

  def delete_old_message!
    Discordrb::API::Channel.delete_message("Bot #{ENV['DISCORD_TOKEN']}", report.requester_channel_id,
                                           report.message_id)
  end

  def send_message(total_time)
    message = completion_message(total_time)

    Discordrb.split_message(message).each do |chunk|
      @bot.send_message(report.requester_channel_id, chunk)
    end
  end

  def completion_message(total_time)
    <<~MESSAGE
      __Character: #{report.character.server.name}/#{report.character.name}__
      Requester: <@#{report.requester_id}>
      View report at: #{ENV['APP_URL']}/simc/reports/#{report.id}

      #{dps_message}

      SIMC version: #{report.json_report['version']}
      Real Simulation Time: #{total_time.round(2)}s
      Cpu Simulation Time: #{report.json_report['sim']['statistics']['elapsed_cpu_seconds'].round(2)}s
      Processed using #{report.json_report['sim']['options']['threads']} threads
      Processed on #{ENV['SERVER_NAME']}
    MESSAGE
  end

  def dps_message
    if report.json_report['sim']['players'].size < 2 && !report.json_report['sim']['profilesets']
      return "**DPS**: #{report.json_report['sim']['statistics']['raid_dps']['mean'].to_i}"
    end

    <<~MESSAGE
      __DPS__
      #{report.json_report['sim']['players'].map do |player|
        "**Set - #{player['name']}**: #{player['collected_data']['dps']['mean'].to_i}"
      end.join("\n")}
      #{if report.json_report['sim']['profilesets']
          report.json_report['sim']['profilesets']['results'].map { |r| "**Set - #{r['name']}**: #{r['mean'].to_i}" }.join("\n")
        end}
    MESSAGE
  end

  def error_message(stderr)
    <<~MESSAGE
      An error has occured while simming #{report.character.server.name}/#{report.character.name}:
      #{stderr}
    MESSAGE
      .tap do |string|
      if Rails.env.development?
        string << "\nDEBUG: #{report.as_json(except: %i[json_report
                                                        html_report])}"
      end
    end
  end
end
