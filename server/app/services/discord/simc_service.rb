class Discord::SimcService
  attr_reader :report
  def initialize(report)
    @report = report
    @bot = Discordrb::Bot.new(token: ENV['DISCORD_TOKEN'])
  end

  def run_sim
    start_time = Time.now
    _stdout, stderr, status = call_simc

    Discordrb::API::Channel.delete_message("Bot #{ENV['DISCORD_TOKEN']}", ENV['DISCORD_CHANNEL'], report.message_id) if report.message_id

    total_time = Time.now - start_time

    return completion(total_time) if status == 0

    error(stderr)
  end

  private

  def call_simc
    Open3.capture3(
      "#{Rails.root.join('bin', 'simc')} armory=#{report.region},"\
      "#{report.server},#{report.character} html=#{html_file_location} "\
      "json2=#{json_file_location}"
    )
  end

  def completion(total_time)
    update_files

    @bot.send_message(ENV['DISCORD_CHANNEL'], completion_message(total_time))
  end

  # should be converted to markdown with erb in the future
  def completion_message(total_time)
    <<~MESSAGE
      __Character: #{report.server}/#{report.character}__
      **DPS**: #{report.json_report['sim']['statistics']['raid_dps']['mean'].to_i}
      View report at: #{ENV['APP_URL']}/simc/reports/#{report.id}

      SIMC version: #{report.json_report['version']}
      Real Simulation Time: #{total_time.round(2)}s
      Cpu Simulation Time: #{report.json_report['sim']['statistics']['elapsed_cpu_seconds'].round(2)}s
      Processed using #{report.json_report['sim']['options']['threads']} threads
    MESSAGE
      .tap { |string| string << "\nDEBUG: #{report.as_json(except: [:json_report, :html_report]).to_s}" if Rails.env.development? }
  end

  def update_files
    report.update(html_report: File.read(html_file_location),
                  json_report: JSON.parse(File.read(json_file_location)))
    delete_files
  end

  def delete_files
    File.delete(html_file_location)
    File.delete(json_file_location)
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
end
