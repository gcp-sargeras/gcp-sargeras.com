class SimcWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(report_id)
    report = Simc::Report.find(report_id)
    html_file_location = "#{Rails.root.join('reports')}/#{report.id}.html"
    json_file_location = "#{Rails.root.join('reports')}/#{report.id}.json"
    stdout, stderr, status = Open3.capture3(
      "#{Rails.root.join('bin', 'simc')} armory=#{report.region},"\
      "#{report.server},#{report.character} html=#{html_file_location} "\
      "json2=#{json_file_location}"
    )

    Discordrb::API::Channel.delete_message("Bot #{ENV['DISCORD_TOKEN']}", ENV['DISCORD_CHANNEL'], report.message_id) if report.message_id

    if status == 0
      report.update(html_report: File.read(html_file_location),
                    json_report: File.read(json_file_location))
      File.delete(html_file_location)
      File.delete(json_file_location)

      puts "Generated simc report: #{report_id}"
      Discordrb::Bot.new(token: ENV['DISCORD_TOKEN']).send_message(
        ENV['DISCORD_CHANNEL'],
        <<~MESSAGE
          Done simulating #{report.server}/#{report.character}
          View report at: #{ENV['APP_URL']}/simc/reports/#{report.id}
        MESSAGE
        .tap { |string| string << "\nDEBUG: #{report.as_json(except: [:json_report, :html_report]).to_s}" if Rails.env.development? }
      )
    else
      Discordrb::Bot.new(token: ENV['DISCORD_TOKEN']).send_message(
        ENV['DISCORD_CHANNEL'],
        <<~MESSAGE
          An error has occured while simming #{report.server}/#{report.character}:
          #{stderr}
        MESSAGE
        .tap { |string| string << "\nDEBUG: #{report.as_json(except: [:json_report, :html_report]).to_s}" if Rails.env.development? }
      )
    end
  end
end
