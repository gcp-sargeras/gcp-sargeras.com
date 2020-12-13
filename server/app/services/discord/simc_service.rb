class Discord::SimcService
  attr_reader :report
  def initialize(report)
    @report = report
    @bot = Discordrb::Bot.new(token: ENV['DISCORD_TOKEN'])
  end

  def run_sim
    start_time = Time.now

    Discordrb::API::Channel.edit_message(
      "Bot #{ENV['DISCORD_TOKEN']}", report.requester_channel_id, report.message_id,
      "Starting sim for #{report.character}"
    )

    _stdout, stderr, status = call_simc

    Discordrb::API::Channel.delete_message("Bot #{ENV['DISCORD_TOKEN']}", report.requester_channel_id, report.message_id)

    total_time = Time.now - start_time

    return completion(total_time) if status == 0

    error(stderr)
  end

  def send_message(total_time)
    Discordrb.split_message(completion_message(total_time)).each do |chunk|
      @bot.send_message(ENV['DISCORD_CHANNEL'], chunk)
    end
  end

  private

  def simc_source
    if report.custom_string.present?
      custom_string_source
    elsif report.requester_attachment_url.present?
      requester_attachement_source
    else
      armory_souce
    end
  end

  def requester_attachement_source
    File.write(custom_file_location, HTTPClient.new.get(report.requester_attachment_url).body)

    custom_file_location
  end

  def custom_string_source
    File.write(custom_file_location, report.custom_string)

    custom_file_location
  end

  def armory_souce
    "armory=#{report.region},#{report.server},#{report.character}"
  end

  def call_simc
    Open3.capture3(
      "#{Rails.root.join('bin', 'simc')} #{simc_source} "\
      "html=#{html_file_location} json2=#{json_file_location} " \
      'threads=8'
    )
  end

  def completion(total_time)
    update_files

    send_message(total_time)
  end

  # should be converted to markdown with erb in the future
  def completion_message(total_time)
    <<~MESSAGE
      __Character: #{report.server}/#{report.character}__
      Requester: <@#{report.requester_id}>
      View report at: #{ENV['APP_URL']}/simc/reports/#{report.id}

      #{dps_message}

      SIMC version: #{report.json_report['version']}
      Real Simulation Time: #{total_time.round(2)}s
      Cpu Simulation Time: #{report.json_report['sim']['statistics']['elapsed_cpu_seconds'].round(2)}s
      Processed using #{report.json_report['sim']['options']['threads']} threads
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

  def update_files
    report.update(html_report: File.read(html_file_location),
                  json_report: JSON.parse(File.read(json_file_location)))
    delete_files
  end

  def delete_files
    File.delete(html_file_location)
    File.delete(json_file_location)
    File.delete(custom_file_location) if report.custom_string.present?
  end

  def error(stderr)
    @bot.send_message(ENV['DISCORD_CHANNEL'], error_message(stderr))
    delete_files
  end

  def error_message(stderr)
    <<~MESSAGE
      An error has occured while simming #{report.server}/#{report.character}:
      #{stderr}
    MESSAGE
      .tap { |string| string << "\nDEBUG: #{report.as_json(except: [:json_report, :html_report]).to_s}" if Rails.env.development? }
  end

  def html_file_location
    "#{Rails.root.join('reports')}/#{report.id}.html"
  end

  def json_file_location
    "#{Rails.root.join('reports')}/#{report.id}.json"
  end

  def custom_file_location
    Dir.mkdir(Rails.root.join('tmp', 'simc').to_s) unless Dir.exist?(Rails.root.join('tmp', 'simc').to_s)
    "#{Rails.root.join('tmp', 'simc')}/#{report.id}.simc"
  end
end
