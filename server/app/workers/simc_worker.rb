class SimcWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(report_id)
    report = Simc::Report.find(report_id)
    stdout, stderr, status = Open3.capture3(
      "#{Rails.root.join('bin', 'simc')} armory=#{report.region},"\
      "#{report.server},#{report.character} html=#{Rails.root.join('reports')}/#{report.id}.html"
    )

    Discordrb::API::Channel.delete_message("Bot #{ENV['DISCORD_TOKEN']}", ENV['DISCORD_CHANNEL'], report.message_id)

    if status == 0
      report.update(html_report: File.read("#{Rails.root.join('reports')}/#{report.id}.html"))
      File.delete("#{Rails.root.join('reports')}/#{report.id}.html")

      puts "Generated simc report: #{report_id}"
      Discordrb::Bot.new(token: ENV['DISCORD_TOKEN']).send_message(
        ENV['DISCORD_CHANNEL'],
        <<~MESSAGE
          Done simulating #{report.server}/#{report.character}
          View report at: #{ENV['APP_URL']}/simc/reports/#{report.id}
        MESSAGE
        .tap { |string| string << "\nDEBUG: #{report.as_json(except: [:text_report, :html_report]).to_s}" if Rails.env.development? }
      )
    else
      Discordrb::Bot.new(token: ENV['DISCORD_TOKEN']).send_message(
        ENV['DISCORD_CHANNEL'],
        <<~MESSAGE
          An error has occured while simming #{report.server}/#{report.character}:
          #{stderr}
        MESSAGE
        .tap { |string| string << "\nDEBUG: #{report.as_json(except: [:text_report, :html_report]).to_s}" if Rails.env.development? }
      )
    end
  end
end
