# frozen_string_literal: true

class SimcWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(report_id)
    SimcService.new(Simc::Report.find(report_id)).run_sim
  end
end
