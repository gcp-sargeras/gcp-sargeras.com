# frozen_string_literal: true

# Creates a simc report for reports created through discord
class DiscordReportSimcWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(report_id)
    report = Simc::Report.find(report_id)

    DiscordSimcService.call(report)
  end
end
