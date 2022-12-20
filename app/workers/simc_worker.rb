# frozen_string_literal: true

# This worker is used to process a Simc report
class SimcWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(report_id)
    report = Simc::Report.find(report_id)

    SimcService.call(report)
  end
end
