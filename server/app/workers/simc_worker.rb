class SimcWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(report_id)
    report = Simc::Report.find(report_id)
    system "#{Rails.root.join('bin', 'simc')} armory=#{report.region},#{report.server},#{report.character} html=#{Rails.root.join('reports')}/#{report.id}.html"

    report.update(html_report: File.read("#{Rails.root.join('reports')}/#{report.id}.html"))
    File.delete("#{Rails.root.join('reports')}/#{report.id}.html")

    puts "Generated simc report: #{report_id}"
    Discordrb::Bot.new(token: ENV['DISCORD_TOKEN']).send_message(
      ENV['DISCORD_CHANNEL'],
      <<~MESSAGE
        Done parsing report for #{report.server}/#{report.character}
        View report at: #{ENV['APP_URL']}/simc/reports/#{report.id}
      MESSAGE
      )
  end
end
