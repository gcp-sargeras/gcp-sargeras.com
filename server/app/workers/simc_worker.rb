class SimcWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(report_id)
    report = Simc::Report.find(report_id)
    stdout, stderr, status = Open3.capture3(
      "#{Rails.root.join('bin', 'simc')} armory=#{report.region},"\
      "#{report.server},#{report.character} html=#{Rails.root.join('reports')}/#{report.id}.html"
    )

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
      )
    else
      Discordrb::Bot.new(token: ENV['DISCORD_TOKEN']).send_message(
        ENV['DISCORD_CHANNEL'],
        <<~MESSAGE
          An error has occured while simming #{report.server}/#{report.character}:
          #{stderr}
        MESSAGE
      )
    end
  end
end
